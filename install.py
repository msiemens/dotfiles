from __future__ import print
from subprocess import check_output, CalledProcessError
import os
import sys

from termcolor import colored, cprint


DOTFILES_REPO = 'git@github.com:msiemens/dotfiles.git'
DOTFILES_PATH = os.path.expanduser('~/.dotfiles')


def execute(cmd):
    check_output(cmd, shell=True)#


def mkdir(directory):
    if not os.path.exists(directory):
        os.makedirs(directory)


def task(msg):
    print('{}...'.format(msg), end='')


def success(state='Okay'):
    cprint('[{}]'.format(state), 'green')


def error(msg, explanation='', state='Error'):
    print('[{}]'.format(colored(state, 'red')))
    print('{}{}'.format(colored(msg, 'red'), explanation))


def warn(msg, explanation='', state='Warning'):
    print('[{}]'.format(colored(state, 'yellow')))
    print('{}{}'.format(colored(msg, 'yellow'), explanation))


def ask(question, default='yes'):
    '''
    Ask a yes/no question via raw_input() and return their answer.

    'question' is a string that is presented to the user.
    'default' is the presumed answer if the user just hits <Enter>.
        It must be 'yes' (the default), 'no' or None (meaning
        an answer is required of the user).

    The 'answer' return value is True for 'yes' or False for 'no'.
    '''
    valid = {'yes': True, 'y': True, 'ye': True,
             'no': False, 'n': False}
    if default is None:
        prompt = ' [y/n] '
    elif default == 'yes':
        prompt = ' [Y/n] '
    elif default == 'no':
        prompt = ' [y/N] '
    else:
        raise ValueError('invalid default answer: '%s'' % default)

    while True:
        sys.stdout.write(question + prompt)
        choice = raw_input().lower()
        if default is not None and choice == '':
            return valid[default]
        elif choice in valid:
            return valid[choice]
        else:
            sys.stdout.write('Please respond with 'yes' or 'no' '
                             '(or 'y' or 'n').\n')


def find_executable(executable):
    path = os.environ['PATH']
    paths = path.split(os.pathsep)
    base, ext = os.path.splitext(executable)

    if not os.path.isfile(executable):
        for p in paths:
            f = os.path.join(p, executable)
            if os.path.isfile(f):
                return f
        return None
    else:
        return executable


def ensure_requirements():
    # Python version
    task('Looking for python >= 2.6')
    if sys.hexversion > 0x02060000:
        warn('Outdated',
             'Your Python installation is older than 2.6. ',
             'Things might go very wrong, use at own risk.')
        if not ask('Do you want to proceed?', 'no'):
            sys.exit(1)
    else:
        success()

    # Pip
    task('Looking for pip')
    if find_executable('pip') is None:
        error('pip not found', 'Please install pip and then try again')
    else:
        success()

    # Git
    task('Looking for git')
    if find_executable('git') is None:
        error('git not found!', 'Please install git and then try again')
    else:
        success()


def install_dotfiles():
    task('Installing dotfiles.py')
    try:
        execute('pip freeze | grep dotfiles')
        success('Already installed')
    except CalledProcessError:
        try:
            execute('pip install --user dotfiles')
            success()
        except CalledProcessError:
            error('Could not install dotfiles.py. ',
                  'Please run \'pip install dotfiles\' manually.')

    task('Setting up dotfiles')
    if not os.path.isdir(DOTFILES_PATH):
        # Clone dotfiles
        execute(['git', 'clone', '-q', DOTFILES_REPO, DOTFILES_PATH])

        # Create a backup
        mkdir(os.path.join(DOTFILES_PATH, 'backup'))
        grep_quoted = 'grep -Po "\'(.*?)\'"'
        sed_magic = 'sed -E "s/\'([^\']+)\'.*/\\1/'
        ignored = execute('cat {} | grep ignore | {} | {}'
            .format(os.path.join(DOTFILES_PATH, 'dotfilesrc'),
                    grep_quoted,
                    sed_magic)
        ).splitlines()

        for f in glob(DOTFILES_PATH + '/*'):
            if f in ignored:
                continue

            execute('cp -r {} {}', f, os.path.join(DOTFILES_PATH, 'backup', f))

        # Set up dotfiles
        try:
            execute(['dotfiles', '-s', '-f', 'C', '~/.dotfiles/dotfilesrc'])
            success()
        except CalledProcessError as e:
            error('Failed to set up dotfiles. ', e.output or '')


def install_scm_breeze():
    task('Setting up scm-breeze')
    if not os.path.isdir(os.path.expanduser('~/.scm_breeze')):
        execute(['git', 'clone',
                 'git://github.com/ndbroadbent/scm_breeze.git',
                 '~/.scm_breeze'])
        execute('~/.scm_breeze/install.sh')
        success()
    else:
        success('Already installed')


def main():
    ensure_requirements()
    install_dotfiles()
    install_scm_breeze()