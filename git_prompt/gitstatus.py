#!/usr/bin/env python
# -*- coding: UTF-8 -*-

# Originally from https://github.com/magicmonty/bash-git-prompt/

from __future__ import print_function
import os

# change those symbols to whatever you prefer
symbols = {'ahead of': '↑·', 'behind': '↓·', 'prehash': ':'}
conf_dir = '~/.git_prompt/'
log = open('/tmp/gitstatus.log', 'a')

from subprocess import Popen, PIPE
import sys

# Read exclude file:
for line in open(os.path.join(os.path.expanduser(conf_dir), 'exclude')):
    path = os.path.expanduser(os.path.expandvars(line))
    if os.path.abspath(path).strip() == os.path.abspath(os.getcwd()).strip():
        sys.exit(0)


################################################################################
# HERE GOES THE REAL PART

def execute(cmd):
    return Popen(cmd.split(' '), stdout=PIPE, stderr=PIPE).communicate()

def countlines(text):
    return len(text.splitlines())

# Get current branch
branch, error = execute('git symbolic-ref HEAD')

error_string = error.decode('utf-8')
if 'fatal: Not a git repository' in error_string:
    sys.exit(0)

branch = branch.decode('utf-8').strip()[11:]

res, error = execute('git diff --name-status')
err_string = error.decode('utf-8')
if 'fatal' in err_string:
    sys.exit(0)

changed_files = [namestat[0] for namestat in res.splitlines()]
staged_files = [namestat[0] for namestat in execute('git diff --staged --name-status')[0].splitlines()]
nb_changed = len(changed_files) - changed_files.count('U')
nb_U = staged_files.count('U')  # TODO: What is 'U'?
nb_staged = len(staged_files) - nb_U
staged = str(nb_staged)
conflicts = str(nb_U)
changed = str(nb_changed)
nb_untracked = countlines(execute('git ls-files --others --exclude-standard')[0])
untracked = str(nb_untracked)

if not nb_changed and not nb_staged and not nb_U and not nb_untracked:
    clean = '1'
else:
    clean = '0'

remote = ''

if not branch:  # not on any branch
    branch = symbols['prehash'] + execute('git rev-parse --short HEAD')[0][:-1]
else:
    remote_name = execute('git config branch.%s.remote' % branch)[0].strip()
    if remote_name:
        merge_name = execute('git config branch.%s.merge' % branch)[0].strip()
        if remote_name == '.':  # local
            remote_ref = merge_name
        else:
            remote_ref = 'refs/remotes/%s/%s' % (remote_name, merge_name[11:])
        revgit = Popen(['git', 'rev-list', '--left-right', '%s...HEAD' % remote_ref], stdout=PIPE, stderr=PIPE)
        revlist = revgit.communicate()[0]
        if revgit.poll():  # fallback to local
            revlist = execute('git rev-list --left-right %s...HEAD' % merge_name)[0]
        behead = revlist.splitlines()
        ahead = len([x for x in behead if x[0] == '>'])
        behind = len(behead) - ahead
        if behind:
            remote += '%s%s' % (symbols['behind'], behind)
        if ahead:
            remote += '%s%s' % (symbols['ahead of'], ahead)

if remote == "":
    remote = '.'

out = '\n'.join([
    str(branch),
    str(remote),
    staged,
    conflicts,
    changed,
    untracked,
    clean])
print(out)