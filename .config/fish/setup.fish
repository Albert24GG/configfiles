#!/usr/bin/env fish

# Install Fisher if not present
if not functions -q fisher
    curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
end

set -l fisher_plugins IlanCosman/tide@v6 jorgebucaran/replay.fish jorgebucaran/autopair.fish meaningful-ooo/sponge

# Install plugins from fish_plugins list
for plugin in $fisher_plugins
    fisher install $plugin
end
