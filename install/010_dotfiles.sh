########################################################################
# Install dotfiles, if not existent
########################################################################

source install/setup.sh
source install/config.sh

task "Setting up dotfiles"

# if [[ ! -d $HOME/.dotfiles ]]; then
    # Clone repo
    # For every file:
    #   Do backup
    # Run dotfiles -s -f -C .dotfiles/dotfilesrc
# else
    # Check, if repo is correct
    #   true: nothing to do
    #   false: other dotfiles already installed!
# fi
success "Dummy"