        RED="\[\033[0;31m\]"
     YELLOW="\[\033[0;33m\]"
    GREEN="\[\033[0;32m\]"
       BLUE="\[\033[0;34m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"
 
function parse_git_branch {
 
  git rev-parse --git-dir &> /dev/null
  git_status="$(git status 2> /dev/null)"
  branch_pattern="^# On branch ([^${IFS}]*)"
  remote_pattern="# Your branch is (.*) of"
  diverge_pattern="# Your branch and (.*) have diverged"
  if [[ ! ${git_status}} =~ "working directory clean" ]]; then
state="${RED}⚡"
  fi
  # add an else if or two here if you want to get more specific
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
remote="${YELLOW}↑"
    else
remote="${YELLOW}↓"
    fi
fi
if [[ ${git_status} =~ ${diverge_pattern} ]]; then
remote="${YELLOW}↕"
  fi
if [[ ${git_status} =~ ${branch_pattern} ]]; then
branch=${BASH_REMATCH[1]}
    echo " (${branch})${remote}${state}"
  fi
}
 
function prompt_func() {
    previous_return_value=$?;
    # prompt="${TITLEBAR}[$RED\w$GREEN$(__git_ps1)$YELLOW$(git_dirty_flag)]$COLOR_NONE "
    prompt="${TITLEBAR}[\w$(parse_git_branch)${COLOR_NONE}]$ "
    if test $previous_return_value -eq 0
    then
PS1="${prompt}"
    else
PS1="${prompt}"
    fi
}
 
PROMPT_COMMAND=prompt_func


# gem open bash completion
_gemopencomplete() {
    local cmd=${COMP_WORDS[0]}
    local subcmd=${COMP_WORDS[1]}
    local cur=${COMP_WORDS[COMP_CWORD]}

    case "$subcmd" in
        open)
            words=`ruby -rubygems -e 'puts Dir["{#{Gem::SourceIndex.installed_spec_directories.join(",")}}/*.gemspec"].collect {|s| File.basename(s).gsub(/\.gemspec$/, "")}'`
            ;;
        *)
            return
            ;;
    esac

    COMPREPLY=($(compgen -W "$words" -- $cur))
    return 0
}

complete -o default -F _gemopencomplete gem



source /usr/local/git/contrib/completion/git-completion.bash
source ~/.bash_login
export EDITOR="vim"
export TERM_EDITOR="mvim"
#export GEM_PATH="/usr/local/lib/ruby/gems/1.8/gems/:$GEM_PATH"
export GEM_OPEN_EDITOR="mvim"
export BUNDLER_EDITOR="mvim"
export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home/"
export EC2_HOME="$HOME/.ec2/ec2-api-tools-1.4.2.3"
export HISTIGNORE="&:ls:[bf]g:exit"

export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/mongodb-osx-x86_64-2009-11-24/bin:$EC2_HOME/bin:/Applications/splunk/bin:$PATH"


source ~/.aws/peregrinator

alias capp='cap production'
alias caps='cap staging'

# needed for mvim/janus to load the gems from rvm ruby and not system
# https://github.com/carlhuda/janus/wiki/Rvm
alias mvim='rvm system do /usr/local/bin/mvim $@'

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.
