#!/bin/bash
set -e

# Running inside docker

if ! [ -f "/.dockerenv" ]
then
    echo "Error: This script must be run inside a docker container"
    exit 1
fi

# Git Configuration

git config --global --add safe.directory ${WORKSPACE_FOLDER}


git config --global user.name "${GITHUB_USER}"
git config --global user.email "${GITHUB_EMAIL}"


# in case we do not have profiles for bash and zsh

touch ~/.bashrc
touch ~/.zshrc

# oh-my-posh setup

echo 'eval "$(oh-my-posh init bash --config $POSH_THEME)"' >> ~/.bashrc
echo 'eval "$(oh-my-posh init zsh --config $POSH_THEME)"' >> ~/.zshrc

# kubectl completion

echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'source <(kubectl completion zsh)' >> ~/.zshrc

# pwsh setup

pwsh ./.devcontainer/setup.ps1


