# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

. ~/.profile

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# dark
#export CLICOLOR=1
#export LSCOLORS=GxFxCxDxBxegedabagaced

# light
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

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

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi


# add to path: my bin folder, and current folder
PATH=${PATH}:~/bin:.:


# set CLASSPATH for java
export CLASSPATH=.;

# tab completion for git commands
source ~/.git-completion.bash

# when inside a git repository, show the current branch in the prompt
source ~/.git-prompt.sh
export PS1='\u@\h \W$(__git_ps1)$ '

# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Open sublime editor instead of text edit
export EDITOR='sub -w'

source ~/.bashrc

export OMSCRIPTS=~/Documents/dev/omscripts
export ANZSCRIPTS=~/Documents/anz-dev/ANZScripts

convert_seconds() 
{
    m=$(($1 / 60))
    s=$(($1 % 60))
    printf "%d:%02ds" $m $s
}

trigger_function()
{
  command_name=$1
  git_branch=`git branch | sed -n '/\* /s///p' | sed -e 's/^ *//' -e 's/ *$//'`
  uppercase_command_name=$(echo $command_name | tr '[:lower:]' '[:upper:]')
  timestamp_start=$(date +%s)

  eval $command_name
  retval=$?

  timestamp_finish=$(date +%s)
  interval=$(($timestamp_finish - $timestamp_start))
  elapsed_time=`convert_seconds $interval`
  current_folder=${PWD##*/}

  if [ $retval -eq 0 ]; then
    title="✅ $uppercase_command_name: Success"
    outcome="Finished"
    sound="default"
  else
    title="❌ $uppercase_command_name: Failure"
    outcome="Failed"
    sound="Basso"
  fi
  
  `terminal-notifier \
    -title "$title" \
    -subtitle "$current_folder ($git_branch)" \
    -message "$outcome in $elapsed_time" \
    -sound "$sound" \
    -sender "com.apple.Terminal"`
}

function ow()
{
  open *.xcworkspace
}

function of()
{
  open .
}

function git_up_https()
{
  GIT_REMOTE_URL=`git config --get remote.origin.url`
  HTTP_REMOTE_URL=`echo $GIT_REMOTE_URL | sed "s/git\@/https:\/\/michael_loo@/g" | sed "s/:outware/\/outware/g"`

  git fetch $HTTP_REMOTE_URL
  git pull $HTTP_REMOTE_URL
}

#set -o vi

export GIT_BRANCH=development
export PATH=/usr/local/bin:$PATH
export VAGRANT_DEFAULT_PROVIDER='vmware_fusion'
export VAGRANT_CWD=$HOME/mavericks-multi/
