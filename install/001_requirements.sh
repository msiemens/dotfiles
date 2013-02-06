########################################################################
# Verify, that the prerequirements are installed:
# - python
# - pip
# - git
########################################################################

source install/setup.sh
source install/config.sh

########################################################################
# python

task "Looking for python >= 2.6"

if ! installed python; then
    error "${COLOR_RED}${FONT_BOLD}Python is not installed!${FONT_DEFAULT}${COLOR_DEFAULT}
Please install Python >= 2.6 and then try again."
fi

python -c 'import sys; sys.exit(0 if sys.hexversion > 0x02060000 else 1)'
if [[ $? != 0 ]]; then
    warning "Outdated" "${COLOR_YELLOW}Your Python installation is older than 2.6${COLOR_DEFAULT}
Things might go very wrong, use at own risk."
    if ! ask "Do you want to proceed?" N; then
        exit 1
    fi
else
    success
fi

########################################################################
# pip

task "Looking for pip"

if ! installed pip; then

    which easy_install &> /dev/null
    if [[ $? != 0 ]]; then
        error "${COLOR_RED}${FONT_BOLD}easy_install not found!${FONT_DEFAULT}${COLOR_DEFAULT}
Please install either:
    - ${FONT_BOLD}easy_install${FONT_DEFAULT} (http://pypi.python.org/pypi/setuptools#installation-instructions), or
    - ${FONT_BOLD}pip${FONT_DEFAULT} (http://www.pip-installer.org/en/latest/installing.html) ${FONT_BOLD}preferred!${FONT_DEFAULT}"
        exit 1
    fi

    warning "${COLOR_YELLOW}pip is not installed!${COLOR_DEFAULT}
Running manual install. Please authenticate as sudoer:"
    sudo easy_install pip

    if [[ $? != 0 ]]; then
        e "${COLOR_RED}${FONT_BOLD}Failed to install pip, please install manually!${FONT_DEFAULT}${COLOR_DEFAULT}"
        exit 1
    fi
else
    success
fi

########################################################################
# git

task "Looking for git"

if ! installed git; then
    error "${COLOR_RED}${FONT_BOLD}git is not installed${FONT_DEFAULT}${COLOR_DEFAULT}
Please install git and then try again"
else
    success
fi