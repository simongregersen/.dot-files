#!/bin/bash

dotfiles="$(pwd)"

declare -a FILES_TO_SYMLINK=(
    'git/.gitconfig'

    'bash/.bash_profile'
    'bash/.bashrc'
)

# Warn user this script will overwrite current dotfiles
while true; do
    read -p "Warning: this will overwrite your current dotfiles. Continue? [y/n] " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

execute() {
    $1 &> /dev/null
    print_result $? "${2:-$1}"
}

print_result() {
    [ $1 -eq 0 ] \
        && print_success "$2" \
            || print_error "$2"

    [ "$3" == "true" ] && [ $1 -ne 0 ] \
        && exit
}

print_error() {
    # Print output in red
    printf "\e[0;31m  [✖] $1 $2\e[0m\n"
}

print_success() {
    # Print output in green
    printf "\e[0;32m  [✔] $1\e[0m\n"
}

answer_is_yes() {
    [[ "$REPLY" =~ ^[Yy]$ ]] \
        && return 0 \
            || return 1
}

ask_for_confirmation() {
    print_question "$1 (y/n) "
    read -n 1
    printf "\n"
}

for i in ${FILES_TO_SYMLINK[@]}; do
    sourceFile="$(pwd)/$i"
    targetFile="$HOME/$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

    if [ ! -e "$targetFile" ]; then
        execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
    elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
        print_success "$targetFile → $sourceFile"
    else
        ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
        if answer_is_yes; then
            rm -rf "$targetFile"
            execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
        else
            print_error "$targetFile → $sourceFile"
        fi
    fi
done
