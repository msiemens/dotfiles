########################################################################
# Install dotfiles, if not existent
########################################################################

source install/setup.sh
source install/config.sh

task "Installing dotfiles.py"

# Check, if dotfiles is already installed
pip freeze | grep dotfiles &> /dev/null

if [[ $? -ne 0 ]]; then
    pip install dotfiles &> /dev/null

    pip freeze | grep dotfiles &> /dev/null
    if [[ $? -ne 0 ]]; then
        error "Could not install dotfiles.py. Please run 'pip install dotfiles' manually."
    fi
else
    success "Already installed"
fi

# Setup dotfiles
task "Setting up dotfiles"

if [[ ! -d $HOME/.dotfiles ]]; then
    log_file="/tmp/dotfiles.log"

    # Clone repo
    git clone -q $DOTFILES_REPO $DOTFILES_PATH

    # Do backup
    files_to_be_replaced=$(cat $DOTFILES_PATH/dotfilesrc | grep ignore | grep -Po "'(.*?)'" | sed -E "s/'([^']+)'.*/\\1/")
    mkdir $DOTFILES_PATH/backup/

    for file in $files_to_be_replaced; do
        cp -r $files_to_be_replaced $DOTFILES_PATH/backup/$files_to_be_replaced 2> /dev/null
    done

    # Setup dotfiles
    dotfiles -s -f -C ~/.dotfiles/dotfilesrc 2> $log_file
    if [[ $? -ne 0 ]]; then
        error $(cat $log_file)
    fi
    success
else
    cd $DOTFILES_PATH
    git remote -v | grep $DOTFILES_REPO &> /dev/null  # Check, if remote is correct

    if [[ $? -ne 0 ]]; then
        error "${COLOR_RED}${FONT_BOLD}3rd party dotfiles found!${FONT_DEFAULT}${COLOR_DEFAULT}
Exiting to prevent overwriting the old environment"
    else
        success "Already installed"
    fi
fi