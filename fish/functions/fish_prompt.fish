function fish_prompt
  if not set -q VIRTUAL_ENV_DISABLE_PROMPT
    set -g VIRTUAL_ENV_DISABLE_PROMPT true
  end
  set_color yellow
  printf '%s' (whoami)
  set_color white
  printf ' at '

  set_color green
  echo -n (prompt_hostname)
  set_color white
  printf ' in '

  set_color blue
  printf '%s' (prompt_pwd)

  printf '%s' (prompt_git magenta yellow)

  # Line 2
  echo
  echo -en '\xF0\x9F\x91\xba  '
  set_color white
end

function prompt_git
  set s ''
  set branchName ''
  # Check if the current directory is in a Git repository.
  if git rev-parse --is-inside-work-tree > /dev/null ^&1
    # check if the current directory is in .git before running git checks
    if [ (git rev-parse --is-inside-git-dir 2> /dev/null) = 'false' ]
      # Ensure the index is up to date.
      git update-index --really-refresh -q > /dev/null ^&1
      # Check for uncommitted changes in the index.
      if not git diff --quiet --ignore-submodules --cached
        set s $s'+'
      end
      # Check for unstaged changes.
      if not git diff-files --quiet --ignore-submodules --
        set s $s'!'
      end
      # Check for untracked files.
      if [ -n (git ls-files --others --exclude-standard) ]
        set s $s'?'
      end
      # Check for stashed files.
      if git rev-parse --verify refs/stash > /dev/null ^&1
        set s $s'$'
      end
    end

    # Get the short symbolic ref.
    # If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
    # Otherwise, just give up.
    set branchName (git symbolic-ref --quiet --short HEAD ^ /dev/null; or \
      git rev-parse --short HEAD ^ /dev/null; or \
      echo '(unknown)')

    if [ -n $s ]
      set s '['$s']'
    end

    set_color white
    printf ' on '
    set_color $argv[1]
    printf '%s ' $branchName
    set_color $argv[2]
    printf '%s' $s
  else
    return
  end
end
