#!/bin/bash

# print colored logs
log_info() {
    echo -e "\033[32m$1\033[0m"
}

log_warning() {
    echo -e "\033[33m$1\033[0m"
}

log_error() {
    echo -e "\033[31m$1\033[0m"
}

log_debug() {
    echo -e "\033[36m$1\033[0m"
}

log_info "Check for dependencies"
# install all dependencies
os_name="$(uname -s)"
if [ "$os_name" = "Linux" ]; then
    distribution=$(grep '^NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
fi

if ! command -v zsh &> /dev/null; then
    log_debug "Installing zsh"
    if [ "$os_name" = "Linux" ]; then
        if [ "$distribution" = "Ubuntu" ] || [ "$distribution" = "Debian GNU/Linux" ]; then
            sudo apt-get install zsh -y
        elif [ "$distribution" = "Amazon Linux" ]; then
            sudo yum install zsh -y
        fi
    elif [ "$os_name" = "Darwin" ]; then
        brew install zsh
    fi
else
    log_info "zsh is already installed"
fi

if ! command -v stow &> /dev/null; then
    log_debug "Installing stow"
    if [ "$os_name" = "Linux" ]; then
        if [ "$distribution" = "Ubuntu" ] || [ "$distribution" = "Debian GNU/Linux" ]; then
            sudo apt-get install stow -y
        elif [ "$distribution" = "Amazon Linux" ]; then
            wget http://ftp.gnu.org/gnu/stow/stow-latest.tar.gz
            tar -xzvf stow-latest.tar.gz
            cd stow-*/
            ./configure
            make
            sudo make install
            sudo yum install perl-File-Copy
            sudo yum install perl-core
        fi

    elif [ "$os_name" = "Darwin" ]; then
        brew install stow
    fi
else
    log_info "Stow is already installed"
fi

if ! command -v oh-my-posh &> /dev/null; then
    log_debug "Installing oh-my-posh"
    if [ "$os_name" = "Linux" ]; then
        sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
        sudo chmod +x /usr/local/bin/oh-my-posh
    elif [ "$os_name" = "Debian GNU/Linux"]; then
        wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-arm -O /usr/local/bin/oh-my-posh
        sudo chmod +x /usr/local/bin/oh-my-posh
    elif [ "$os_name" = "Darwin" ]; then
        brew install jandedobbeleer/oh-my-posh/oh-my-posh
    fi
else
    log_info "oh-my-posh is already installed"
    log_debug "Updating oh-my-posh"
    sudo oh-my-posh upgrade
fi
source ~/.zshrc
# Ensure the user's shell is zsh
if [ "$SHELL" != "/bin/zsh" ]; then
    log_info "Changing the user's shell to zsh"
    chsh -s /bin/zsh
    log_info "Shell changed to zsh. Please log out and log back in for the change to take effect."
fi

log_info "Installation completed. Please restart your terminal."