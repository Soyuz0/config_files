#!/bin/bash
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install make gcc ripgrep unzip git xclip npm python3.10-venv neovim
# git clone https://github.com/Soyuz0/config_files.git "${XDG_CONFIG_HOME:-$HOME/.config}"
# git init "${XDG_CONFIG_HOME:-$HOME/.config}"
# cd "${XDG_CONFIG_HOME:-$HOME/.config}"
# git remote add origin https://github.com/Soyuz0/config_files.git
# git fetch
# git checkout -t origin/main
