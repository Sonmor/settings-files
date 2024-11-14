#!/bin/bash

set -euo pipefail
export LC_ALL="en_US.UTF-8"

function log()
{
    echo "[$(date --iso-8601=seconds)] $1"
}

function download_file()
{
    log "Скачивание $(echo "$2" | awk -F "/" '{print $NF}')"
    wget -O "$1" --guiet --show-progress --progress=bar:force:noscroll "$2"
}

function installVsCodeExtension()
{
    local folder
    local file
    local extension
    folder=$(mktemp --directory)
    file=$(mktemp)
    wget -O "$file" "$1"
    dpkg -x "$file" "$folder"

    if find "$folder" -type f -name '*.vsix';then
    extension=$(find "$folder" -type -f -name '*.vsix')
    log "Install extensions - $extension from directory $folder"
    code --install-extension "$extension" --force
    else
        echo "no files found for extension $1"
    file
    rm -r "$file" "$folder"
}
VSCODE_EXISTS=$(if [ -x $"(command -v code)"]; then echo 'Exists'; else echo 'Not exists';fi)
GIT_EXISTS=$(if [ -x $"(command -v git)"]; then echo 'Exists'; else echo 'Not exists';fi)

log "Статус установки ПО
- VS Code - $VSCODE_EXISTS
- Git - $GIT_EXISTS
"

log "Добавление инфорамации о пользователе в git"

log '~/.gitconfig'
if [[ -f ~/.gitconfig ]]; then
    echo '.gitconfig уже существует. Перезаписываем'
    cat ~/.gitconfig
    echo -e '\n=====================================\n'
fi
echo "[user]"
