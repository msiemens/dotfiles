# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Git Flow completion
if [ -f ~/.git-flow-completion.sh ]; then
    . ~/.git-flow-completion.sh
fi



# Prompt
# See: http://wiki.ubuntuusers.de/Bash/Prompt
# PS1='[\[\033[1;34m\]\u\[\033[1;33m\]@\[\033[1;32m\]\h:\[\033[1;35m\]\w\[\033[1;36m\]]\[\033[1;31m\]\\$\[\033[0m\] '

# See: http://thesmithfam.org/blog/2009/01/06/best-bash-prompt-ever/
BLACK="\[\033[0;30m\]"
DARK_GRAY="\[\033[1;30m\]"
LIGHT_GRAY="\[\033[0;37m\]"
BLUE="\[\033[0;34m\]"
LIGHT_BLUE="\[\033[1;34m\]"
GREEN="\[\033[0;32m\]"
LIGHT_GREEN="\[\033[1;32m\]"
CYAN="\[\033[0;36m\]"
LIGHT_CYAN="\[\033[1;36m\]"
RED="\[\033[0;31m\]"
LIGHT_RED="\[\033[1;31m\]"
PURPLE="\[\033[0;35m\]"
LIGHT_PURPLE="\[\033[1;35m\]"
BROWN="\[\033[0;33m\]"
YELLOW="\[\033[1;33m\]"
WHITE="\[\033[1;37m\]"
DEFAULT_COLOR="\[\033[00m\]"

BOLD=$(tput bold)

# See: https://github.com/magicmonty/bash-git-prompt
__GIT_PROMPT_DIR=~/.git_prompt
GIT_PROMPT_PREFIX=":$PURPLE"
GIT_PROMPT_SUFFIX="$GREEN"
GIT_PROMPT_SEPARATOR="|"
GIT_PROMPT_BRANCH="${PURPLE}"
GIT_PROMPT_STAGED="${BOLD}${RED}● "
GIT_PROMPT_CONFLICTS="${BOLD}${RED}✖ "
GIT_PROMPT_CHANGED="${BOLD}${BLUE}✚ "
GIT_PROMPT_REMOTE="${BOLD} "
GIT_PROMPT_UNTRACKED="…"
GIT_PROMPT_CLEAN="${BOLD}${GREEN}✔"

function update_current_git_vars() {
    unset __CURRENT_GIT_STATUS
    local gitstatus="${__GIT_PROMPT_DIR}/gitstatus.py"

    _GIT_STATUS=$(python $gitstatus)
    __CURRENT_GIT_STATUS=($_GIT_STATUS)
	GIT_BRANCH=${__CURRENT_GIT_STATUS[0]}
	GIT_REMOTE=${__CURRENT_GIT_STATUS[1]}
    if [[ "." == "$GIT_REMOTE" ]]; then
		unset GIT_REMOTE
	fi
	GIT_STAGED=${__CURRENT_GIT_STATUS[2]}
	GIT_CONFLICTS=${__CURRENT_GIT_STATUS[3]}
	GIT_CHANGED=${__CURRENT_GIT_STATUS[4]}
	GIT_UNTRACKED=${__CURRENT_GIT_STATUS[5]}
	GIT_CLEAN=${__CURRENT_GIT_STATUS[6]}
}

function myPrompt() {
	history -a; history -n;

	update_current_git_vars

	if [ -n "$__CURRENT_GIT_STATUS" ]; then
	  STATUS="$GIT_PROMPT_PREFIX$GIT_PROMPT_BRANCH$GIT_BRANCH$DEFAULT_COLOR"

	  if [ -n "$GIT_REMOTE" ]; then
		  STATUS="$STATUS$GIT_PROMPT_REMOTE$GIT_REMOTE$DEFAULT_COLOR"
	  fi

	  STATUS="$STATUS$GIT_PROMPT_SEPARATOR"
	  if [ "$GIT_STAGED" -ne "0" ]; then
		  STATUS="$STATUS$GIT_PROMPT_STAGED$GIT_STAGED$DEFAULT_COLOR"
	  fi

	  if [ "$GIT_CONFLICTS" -ne "0" ]; then
		  STATUS="$STATUS$GIT_PROMPT_CONFLICTS$GIT_CONFLICTS$DEFAULT_COLOR"
	  fi
	  if [ "$GIT_CHANGED" -ne "0" ]; then
		  STATUS="$STATUS$GIT_PROMPT_CHANGED$GIT_CHANGED$DEFAULT_COLOR"
	  fi
	  if [ "$GIT_UNTRACKED" -ne "0" ]; then
		  STATUS="$STATUS$GIT_PROMPT_UNTRACKED$GIT_UNTRACKED$DEFAULT_COLOR"
	  fi
	  if [ "$GIT_CLEAN" -eq "1" ]; then
		  STATUS="$STATUS$GIT_PROMPT_CLEAN"
	  fi
	  STATUS="$DEFAULT_COLOR$STATUS$GIT_PROMPT_SUFFIX"
	else
	  STATUS=""
	fi

	PS1="\`if [ \$? = 0 ];
	    then
		echo -e '$GREEN--( $DARK_GRAY\u$GREEN )--( $YELLOW\w$STATUS$GREEN )-- :)\n--\$$DEFAULT_COLOR ';
	    else
		echo -e '$LIGHT_RED--( $DARK_GRAY\u$LIGHT_RED )--( $YELLOW\w$LIGHT_RED$STATUS$LIGHT_RED )-- :(\n--\$$DEFAULT_COLOR ';
	    fi; \`"
}

PROMPT_COMMAND=myPrompt


[ -s "$HOME/.scm_breeze/scm_breeze.sh" ] && source "$HOME/.scm_breeze/scm_breeze.sh"

export GIT_REPO_DIR=$HOME/Coding
export PYTHONSTARTUP=$HOME/.pystartup

source $HOME/.ssh/setup.sh


# http://superuser.com/questions/37576/can-history-files-be-unified-in-bash
shopt -s histappend


# Auto-screen invocation. see: http://taint.org/wk/RemoteLoginAutoScreen
# if we're coming from a remote SSH connection, in an interactive session
# then automatically put us into a screen(1) session.   Only try once
# -- if $STARTED_SCREEN is set, don't try it again, to avoid looping
# if screen fails for some reason.

if [ "$PS1" != "" -a "$TERM" != "screen" -a "${STARTED_SCREEN:-x}" = x -a "${SSH_TTY:-x}" != x ]; then
    STARTED_SCREEN=1 ; export STARTED_SCREEN
    [ -d $HOME/lib/screen-logs ] || mkdir -p $HOME/lib/screen-logs
    sleep 1
    screen -RR && exit 0
    # normally, execution of this rc script ends here...
    echo "Screen failed! continuing with normal bash startup"
fi