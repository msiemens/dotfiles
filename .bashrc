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

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  # We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

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

export PS1="\`if [ \$? = 0 ];
    then
        echo -e '$GREEN--( $DARK_GRAY\u$GREEN )--( $YELLOW\w$GREEN )-- :)\n--\$$DEFAULT_COLOR ';
    else
        echo -e '$LIGHT_RED--( $DARK_GRAY\u$LIGHT_RED )--( $YELLOW\w$LIGHT_RED )-- :(\n--\$$DEFAULT_COLOR ';
    fi; \`"



[ -s "$HOME/.scm_breeze/scm_breeze.sh" ] && source "$HOME/.scm_breeze/scm_breeze.sh"

export GIT_REPO_DIR=$HOME/Coding
export PYTHONSTARTUP=$HOME/.pystartup

[ -s "$HOME/.ssh/setup.sh" ] && source "$HOME/.ssh/setup.sh"


# http://superuser.com/questions/37576/can-history-files-be-unified-in-bash
shopt -s histappend
PROMPT_COMMAND="history -a; history -n"
