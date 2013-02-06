########################################################################
# COLORS and OUTPUT

export COLOR_BLACK="\033[0;30m"
export COLOR_DARK_GRAY="\033[1;30m"
export COLOR_LIGHT_GRAY="\033[0;37m"
export COLOR_BLUE="\033[0;34m"
export COLOR_LIGHT_BLUE="\033[1;34m"
export COLOR_GREEN="\033[0;32m"
export COLOR_LIGHT_GREEN="\033[1;32m"
export COLOR_CYAN="\033[0;36m"
export COLOR_LIGHT_CYAN="\033[1;36m"
export COLOR_RED="\033[0;31m"
export COLOR_LIGHT_RED="\033[1;31m"
export COLOR_PURPLE="\033[0;35m"
export COLOR_LIGHT_PURPLE="\033[1;35m"
export COLOR_BROWN="\033[0;33m"
export COLOR_YELLOW="\033[1;33m"
export COLOR_WHITE="\033[1;37m"
export COLOR_DEFAULT="\033[00m"
export FONT_BOLD=$(tput bold)
export FONT_DEFAULT=$(tput sgr0)  # RESETS COLORS, TOO!

shopt -s expand_aliases
alias e="echo -e"

########################################################################
# USER INPUT
function ask {
    while true; do

        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        # Ask the question
        read -p "$1 [$prompt] " REPLY

        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi

        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}

########################################################################
# STATUS OUTPUT
function task {
    e -n "$1... "
}

function success {
    e "[${COLOR_GREEN}Okay${COLOR_DEFAULT}]"
}

function error {
    state="Error"
    message=""

    if [[ $# -eq 2 ]]; then
        state=$1
        message=$2
    elif [[ $# -eq 1 ]]; then
        message=$1
    fi

    e "[${COLOR_RED}${state}${COLOR_DEFAULT}]"
    e "$message"
    exit 1
}

function warning {
    state="Warning"
    message=""

    if [[ $# -eq 2 ]]; then
        state=$1
        message=$2
    elif [[ $# -eq 1 ]]; then
        message=$1
    fi

    e "[${COLOR_YELLOW}${state}${COLOR_DEFAULT}]"
    e "$message"
}

########################################################################
# Misc. TESTS

function installed {
    which $1 &> /dev/null
    return $?
}