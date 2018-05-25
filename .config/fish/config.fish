set PATH /usr/local/bin $PATH
set PATH $HOME/.rbenv/shims $PATH
set -x PATH $HOME/.fastlane/bin $PATH
rbenv rehash >/dev/null ^&1
status --is-interactive; and source (rbenv init -|psub)

function fish_prompt --description 'Write out the prompt'
    # Just calculate these once, to save a few cycles when displaying the prompt
    if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
    end

    if not set -q __fish_prompt_normal
    set -g __fish_prompt_normal (set_color normal)
    end

    if not set -q __git_cb
    set __git_cb ":"(set_color brown)(git branch ^/dev/null | grep \* | sed 's/* //')(set_color normal)""
    end

    switch $USER

    case root

    if not set -q __fish_prompt_cwd
        if set -q fish_color_cwd_root
            set -g __fish_prompt_cwd (set_color $fish_color_cwd_root)
        else
            set -g __fish_prompt_cwd (set_color $fish_color_cwd)
        end
    end

    printf '%s@%s:%s%s%s%s# ' $USER $__fish_prompt_hostname "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal" $__git_cb

    case '*'

    if not set -q __fish_prompt_cwd
        set -g __fish_prompt_cwd (set_color $fish_color_cwd)
    end

    printf '%s@%s:%s%s%s%s$ ' $USER $__fish_prompt_hostname "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal" $__git_cb

    end
end

function ow --description 'Open workspace in current folder'
   bash -c "[[ `ls *.xcworkspace 2>/dev/null` ]] && open *.xcworkspace -a /Applications/Xcode.app || open *.xcodeproj -a /Applications/Xcode.app"
end

function of --description 'Open current folder'
   open .
end

function ost --description 'Open Source Tree in current folder'
   open $argv[1] -a SourceTree
end

function ogb --description 'Open Gitbox in current folder'
   open . -a Gitbox
end

function dev --description 'Open dev folder'
   cd ~/Documents/dev
end

function ops --description 'Open ops folder'
   cd ~/Documents/DevOps
end

function anz --description 'Open anz dev folder'
   cd ~/Documents/anz-dev
end

function pod_push_anz --description 'Update podspec on ANZ-Repo with a pod repo push'
   pod repo push master *.podspec --verbose
end

function ssh_ec2 --description 'Open ssh connection to the EC2 instance which backs up the bitbucket repos'
   ssh -i ~/Documents/dev/omscripts/Backup/.ssh/repo-backup.pem $argv
end

function ssh_jira --description 'Open ssh connection to the EC2 instance which hosts jira'
   ssh -i ~/.ssh/Atlassian.pem ec2-user@ec2-54-252-23-10.ap-southeast-2.compute.amazonaws.com
end

function sc --description 'Open ssh connection to the Jenkins machines as continuous'
   ssh continuous@$argv[1].local
end

function sgo --description 'Open ssh connection to the Jenkins machines as go'
   ssh gomoney@$argv[1].local
end

function sgr --description 'Open ssh connection to the Jenkins machines as grow'
   ssh growmoney@$argv[1].local
end

function sub --description 'Open file with sublime'
  open $argv -a Sublime\ Text\ 2
end

function b --description 'Open bash as a terminal session'
  bash -l
end

function osc --description 'Open screen share on given url'
  open vnc://$argv[1]
end

function vncm --description 'Open vncviewer on jenkins master'
  vncviewer jade.local:5913
end

function vncs1 --description 'Open vncviewer on jenkins slave 1'
  vncviewer jade.local:5917
end

function vncs2 --description 'Open vncviewer on jenkins slave 2'
  vncviewer moss.local:5918
end

function vncs3 --description 'Open vncviewer on jenkins slave 3'
  vncviewer moss.local:5919
end

function vncs4 --description 'Open vncviewer on jenkins slave 4'
  vncviewer iceland.local:5920
end

function vncs5 --description 'Open vncviewer on jenkins slave 5'
  vncviewer iceland.local:5921
end

function mount_omjenkins --description 'Mount OMJenkins to /Volumes/OMJenkins'
  mkdir /Volumes/OMJenkins; mount -t nfs berkeley.local:/volume1/OMJenkins /Volumes/OMJenkins
end

function pwd_generate --description 'Generate a random password of 8 characters'
  openssl rand -base64 6
end

function bl --description 'Run bundle install local'
  bundle install --local --path vendor/cache
end

function be --description 'Run bundle exec'
  bundle exec $argv
end

function fast_dev --description "Run fastlane ci_dev with swift build optimised"
  export SCAN_XCARGS="SWIFT_WHOLE_MODULE_OPTIMIZATION=YES"; be fastlane ci_dev
end

function brake --description 'Run bundle exec rake'
  bundle exec rake $argv
end

