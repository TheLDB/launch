#!/usr/bin/env bash
cd ~
shopt -s dotglob

notify() {
	echo -e "\033[0;34m[i]\033[0m $1" >&2
}

error() {
	echo -e "\033[0;31m[x]\033[0m $1" >&2
}

DOTDIR="$HOME/.dotfiles"

# Check for sudo
if [[ $UID != 0 ]]; then
	if $(sudo -v); then
		SUDO=sudo
	else
		SUDO="UNSET"
	fi
fi

builtin cd "$DOTDIR"
command git submodule update --init
builtin cd -

command touch "$HOME/.hushlogin"

# Configure git config
command rm -rf "$HOME/.gitconfig"
command ln -s "$DOTDIR/.gitconfig" "$HOME/.gitconfig"
command chmod +x $DOTDIR/githooks/* # Can't be in quotes to fix Linux glob behavior

command rm -rf "$HOME/.huskyrc"
command ln -s "$DOTDIR/.huskyrc" "$HOME/.huskyrc"
command ln -s "$DOTDIR/.zshrc" "$HOME/.zshrc"

command rm -rf "$HOME/.tmux.conf"
command ln -s "$DOTDIR/.tmux.conf" "$HOME/.tmux.conf"

echo "Include ~/.dotfiles/ssh.config" | sudo tee -a "$HOME/.ssh/config"

if [[ $(uname -s) == "Darwin" ]]; then
	source "$DOTDIR/bootstrap/macos.sh"
fi

if [[ $(uname -s) == "Linux" ]]; then
	source /etc/os-release
	if [[ $ID != "ubuntu" && $ID_LIKE != "debian" ]]; then
		error "Not running on Ubuntu"
		exit 2
	fi

	if [[ $VERSION_ID != "22.04" ]]; then
		error "Not running on Ubuntu Jammy Jellyfish (22.04)"
		exit 3
	fi

	source "$DOTDIR/bootstrap/linux.sh"
fi
