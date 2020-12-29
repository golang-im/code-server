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

# echo "Install oh my zsh"
# wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh -O - | zsh || true