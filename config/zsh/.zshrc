# Instantly load typewritten prompt
fpath+=($DOTDIR/vendor/typewritten)
autoload -U promptinit; promptinit

export TYPEWRITTEN_ARROW_SYMBOL="➜"
export TYPEWRITTEN_RELATIVE_PATH="home"
prompt typewritten

source "$HOME/.cargo/env" # Rust environment

zstyle ":completion:*" use-cache on
zstyle ":completion:*" menu select
zstyle ":completion:*" file-list all
zstyle ":completion:*" completer _extensions _complete _approximate

zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

if [[ "$OS" == "Darwin" ]]; then # Different cache path for macOS
	zstyle ":completion:*" cache-path "$HOME/Library/Caches/zsh/.zcompcache"
else
	zstyle ":completion:*" cache-path "$HOME/.cache/zsh/.zcompcache"
fi

# Random Globals
export BAT_THEME="TwoDark"

# Laziness
export dd="$DOTDIR"
export gpg="$HOME/.gnupg"

# Aliases
alias g="git"
alias t="task"
alias p="pnpm"
alias c="cargo"
alias cat="bat"
alias d="docker"
alias k="kubectl"
alias find="fd"

alias l="exa -l"
alias la="exa -la"
alias ll="exa -lah"
alias ls="exa -l"

alias f="fzf"
alias n="/Applications/Neovim.app/Contents/MacOS/Neovim --maximized"
alias nano="nvim"
alias vi="/Applications/Neovim.app/Contents/MacOS/Neovim --maximized"
alias vim="nvim"
alias code="/Applications/Neovim.app/Contents/MacOS/Neovim --maximized"

alias mk="minikube"
alias devc="devcontainer"
alias mkmk="minikube start --driver=docker --kubernetes-version=v1.25.0"

# Platform specific configuration
if [[ "$OS" == "Darwin" ]]; then
	source "$DOTDIR/config/zsh/macos.zsh"
	
	[[ -f ${ZDOTDIR:-$HOME}/.zcompdump ]] && COMPINIT_STAT=$(/usr/bin/stat -f "%Sm" -t "%j" ${ZDOTDIR:-$HOME}/.zcompdump)
else
	source "$DOTDIR/config/zsh/linux.zsh"
	[[ -f ${ZDOTDIR:-$HOME}/.zcompdump ]] && COMPINIT_STAT=$(/usr/bin/stat -c "%Y" ${ZDOTDIR:-$HOME}/.zcompdump | date +"%j")
fi

# Load completions and suggestions at the end
fpath+=($DOTDIR/vendor/zsh-completions/src)
autoload -Uz compinit

if [ $(date +"%j") != $COMPINIT_STAT ]; then
	compinit
else
	compinit -C
fi

source "$DOTDIR/vendor/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Helper function to maintain dotfiles
dotfiles() {
	case "$1" in
		"source")
			source "$ZDOTDIR/.zlogin"
			source "$ZDOTDIR/.zshrc"
			source "$HOME/.zshenv"
			;;
		"update")
			command git -C "$DOTDIR" stash
			command git -C "$DOTDIR" pull
			command git -C "$DOTDIR" stash pop

			source "$ZDOTDIR/.zlogin"
			source "$ZDOTDIR/.zshrc"
			source "$HOME/.zshenv"
			;;
		"reset")
			command git -C "$DOTDIR" reset --hard
			command git -C "$DOTDIR" clean -fd
			;;
		"bundle")
			command brew bundle dump --force --file="$DOTDIR/Brewfile"
			;;
		*)
			echo "Usage: dotfiles <source|update|reset|bundle>"
			;;
	esac
}

