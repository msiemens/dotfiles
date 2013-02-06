########################################################################
# Install dotfiles, if not existent
########################################################################

source install/setup.sh
source install/config.sh

if [[ ! -d $HOME/.dotfiles ]]; then
    # Clone repo
    # For every file:
    #   Do backup
    # Run dotfiles -s -f -C .dotfiles/dotfilesrc
    echo "pass"
else
    # Check, if repo is correct
    #   true: nothing to do
    #   false: other dotfiles already installed!
    echo "pass"
fi