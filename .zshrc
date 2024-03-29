# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"


# Set theme
ZSH_THEME="powerlevel10k/powerlevel10k"


# Set plugins
plugins=(git colored-man-pages fast-syntax-highlighting)


# Start oh-my-zsh
source $ZSH/oh-my-zsh.sh


# Preferred editor 
export EDITOR=vim


# Aliases
alias diskmngr="ncdu"
alias neofetch="neofetch --ascii $HOME/.config/neofetch/arch_logo"


# Neofetch
neofetch


# BEGIN_KITTY_SHELL_INTEGRATION
if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/zsh/kitty.zsh"; then source "$KITTY_INSTALLATION_DIR/shell-integration/zsh/kitty.zsh"; fi
# END_KITTY_SHELL_INTEGRATION


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# Set ripgrep as default for fzf
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m'
fi
