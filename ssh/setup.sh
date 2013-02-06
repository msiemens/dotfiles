#!/bin/sh
# This script is intended to reside in your ~/.ssh directory (don't
# forget to 'chmod 700'), and be included in your shell init script.
# It works by checking for a working ssh agent, otherwise it starts one
# and requests the passphrase.
#
# For bash and ksh users:
# include the following in your ~/.bashrc or ~/.kshrc or ~/.profile
#       . $HOME/.ssh/setup

# Enable this if using you have GNOME and the following program.
#SSH_ASKPASS=/usr/libexec/ssh/gnome-ssh-askpass
#export SSH_ASKPASS

SSH_ENV=$HOME/.ssh/environment.`hostname`

function start_agent {
        echo "Initialising new Secure Shell agent..."
        ssh-agent -s | head -2 > ${SSH_ENV}
        chmod 600 ${SSH_ENV}
        . ${SSH_ENV} > /dev/null
        #ssh-add < /dev/null
}

# Source SSH settings, if applicable
if [ -f "${SSH_ENV}" ]; then
       . ${SSH_ENV} > /dev/null
       kill -0 ${SSH_AGENT_PID} 2>/dev/null || {
               start_agent;
       }
else
       start_agent;    
fi
