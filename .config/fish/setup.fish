#!/usr/bin/env fish

# Install Fisher if not present
if not functions -q fisher
    curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
end

# Install plugins from fish_plugins file
fisher update
