### alias
alias e='emacs'
alias g='git'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../'
alias ~='cd ~'

### PS1
# function to get the current git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
# modify bash output
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

### git completion
if [ -f ~/dotfiles/git-completion.bash ]; then
    source ~/dotfiles/git-completion.bash
fi;

### functions
function extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)      tar xjf $1              ;;
            *.tar.gz)       tar xzf $1              ;;
            *.bz2)          bunzip2 $1              ;;
            *.rar)          rar x $1                ;;
            *.gz)           gunzip $1               ;;
            *.tar)          tar xf $1               ;;
            *.tbz2)         tar xjf $1              ;;
            *.tgz)          tar xzf $1              ;;
            *.zip)          unzip $1                ;;
            *.Z)            uncompress $1   ;;
            *)                      echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
