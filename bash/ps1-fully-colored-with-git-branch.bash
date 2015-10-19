# -*- sh -*-

: ${PS1_MAXDIRLEN:=25}
: ${PS1_GITBRANCH:=yes}

export PS1_MAXDIRLEN
export PS1_GITBRANCH

PROMPT_COMMAND ()
{
  # Exit status
  EXIT_STATUS=$?
  PS1EXIT=${EXIT_STATUS##0}

  # Working directory
  PS1CLIP=${PWD: $((-PS1_MAXDIRLEN))}
  local p=${PS1CLIP:+${PWD: $((-(PS1_MAXDIRLEN-1)))}}
  PS1CLIP=${PS1CLIP:+<}
  PS1DIR=${p:-$PWD}

  # Git info
  if [ "$PS1_GITBRANCH" = yes ]; then
    PS1GIT=$(git branch 2>/dev/null|sed -n 's/^* //p')
  else
    PS1GIT=
  fi
}

export PROMPT_COMMAND=PROMPT_COMMAND

ps1 ()
{
  local bold="\[\e[1m\]"
  local black="\[\e[30m\]"
  local red="\[\e[31m\]"
  local green="\[\e[32m\]"
  local yellow="\[\e[33m\]"
  local blue="\[\e[34m\]"
  local magenta="\[\e[35m\]"
  local cyan="\[\e[36m\]"
  local reset="\[\e[m\]"

  echo -n $bold

  # exit code
  echo -n '${PS1EXIT:+'$black'['$red'$PS1EXIT'$black'] }'

  # user @ host
  echo -n $magenta'\u'$black'@'$cyan'\h'$black':'

  # directory
  echo -n $red'$PS1CLIP'$blue'${PS1DIR////'$black'/'$blue'}'

  # git info
  echo -n '${PS1GIT:+'$black':'$green'$PS1GIT}'

  # command number
  echo -n $black':'$yellow'\!'$black'\$'

  # reset colors
  echo $reset' '
}

export PS1=$(ps1)

unset ps1
