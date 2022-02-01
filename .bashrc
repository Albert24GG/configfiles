export OSH=/home/albert/.oh-my-bash

# Oh-my-bash theme
OSH_THEME="powerline-multiline"

# Oh-my-bash plugins
plugins=(
  git
  bashmarks
  progress
)

# Start Oh-my-bash
source $OSH/oh-my-bash.sh

# Set main editor
export EDITOR='vim'

# Aliases
alias diskmngr="ncdu"
alias neofetch="neofetch --ascii ~/.config/neofetch/arch_logo"

# Neofetch
neofetch


# BEGIN_KITTY_SHELL_INTEGRATION
if test -n "$KITTY_INSTALLATION_DIR" -a -e "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; then source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"; fi
# END_KITTY_SHELL_INTEGRATION
