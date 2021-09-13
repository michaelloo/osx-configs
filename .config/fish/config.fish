set PATH /usr/local/bin $PATH
set PATH ~/Library/Python/3.7/bin $PATH
set LC_ALL en_US.UTF-8
#set PATH $HOME/.rbenv/versions $PATH
#set PATH $HOME/.rbenv/shims $PATH
#rbenv rehash >/dev/null ^&1

status --is-interactive; and source (rbenv init -|psub)

function fish_prompt
    # Just calculate these once, to save a few cycles when displaying the prompt
    if not set -q __fish_prompt_hostname
        set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
    end

    if not set -q __fish_prompt_normal
        set -g __fish_prompt_normal (set_color normal)
    end

    if not set -q __git_cb
        set __git_cb ":"(set_color brown)(git branch 2>/dev/null | grep \* | sed 's/* //')(set_color normal)""
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
   open . -a SourceTree
end

function dev --description 'Open dev folder'
   cd ~/Documents/dev
end

function b --description 'Open bash as a terminal session'
  bash -l
end

function pwd_generate --description 'Generate a random password of 8 characters'
  openssl rand -base64 6
end

function bl --description 'Run bundle install local'
  bundle install --local --path vendor
end

function be --description 'Run bundle exec'
  bundle exec $argv
end

function brake --description 'Run bundle exec rake'
  bundle exec rake $argv
end
