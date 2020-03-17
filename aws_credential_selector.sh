#!/bin/bash -eu

selected=$(aws-vault ls | tail +4 | while read line; do echo ${line} | cut -d' ' -f1,2; done | peco --prompt 'Select Profile >')

profile=$(echo ${selected} | cut -d' ' -f1)
credential=$(echo ${selected} | cut -d' ' -f2)

if [[ ${credential} == "-" ]]; then
  source_profile=$(aws --profile ${profile} configure get source_profile)
  role_arn=$(aws --profile ${profile} configure get role_arn)
  aws --profile ${source_profile} sts assume-role --role-arn ${role_arn} --role-session-name assume-role | jq ".Credentials + {Version: 1}"
else
  aws-vault exec -j ${profile} --no-session
fi
