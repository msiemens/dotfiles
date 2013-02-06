source install/setup.sh
source install/config.sh

task "Setting up scm-breeze"

if [[ ! -d ~/.scm_breeze/ ]]; then
    git clone git://github.com/ndbroadbent/scm_breeze.git ~/.scm_breeze
    ~/.scm_breeze/install.sh > /dev/null
    source ~/.bashrc

    success
else
    success "Already installed"
fi