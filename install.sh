#!/usr/bin/env bash

apt-get update && apt-get install -y wget sudo zsh unzip vim


echo "Install terraform"
VERSION=0.14.3
DOWNLOAD_URL=https://releases.hashicorp.com/terraform/$VERSION/terraform_${VERSION}_linux_amd64.zip

cd /tmp
wget $DOWNLOAD_URL
unzip terraform_${VERSION}_linux_amd64.zip
mv terraform /usr/bin/terraform

echo "Install tflint"
wget https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh && bash install_linux.sh

echo "Install oh my zsh"
wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh  -- \ 
    -t https://github.com/denysdovhan/spaceship-prompt \
    -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
    -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
    -p git \
    -p ssh-agent \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions \
    | zsh || true