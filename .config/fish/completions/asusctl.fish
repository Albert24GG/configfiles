
function cmd_contains_seq --description 'Return true if the commandline ends with the given sequence'
    set -l pattern (string join ' ' $argv)
    set pattern (string join '' $pattern '\s*?[\w-]*?$')
    set -l cmd (commandline -p)
    string match -r $pattern $cmd
end

# Global options
complete -c asusctl -s h -l help -d "Show help"
complete -c asusctl -s v -l version -d "Show version"
complete -c asusctl -s s -l show-supported -d "Show supported functions"
complete -c asusctl -s k -l kbd-bright -x -a "off low med high" -d "Set keyboard brightness"
complete -c asusctl -s n -l next-kbd-bright -d "Toggle next keyboard brightness"
complete -c asusctl -s p -l prev-kbd-bright -d "Toggle previous keyboard brightness"
complete -c asusctl -s c -l chg-limit -x -d "Set battery charge limit" -a "(seq 20 100)"
complete -c asusctl -s o -l one-shot-chg -d "Toggle one-shot battery charge"

# Subcommands
set -l subcommands aura aura-power profile fan-curve graphics scsi armoury
complete -c asusctl -n "not __fish_seen_subcommand_from $subcommands" -xa "$subcommands"

# aura subcommand
set -l aura_modes static breathe rainbow-cycle rainbow-wave pulse
complete -c asusctl -n "cmd_contains_seq aura" -f -a "$aura_modes"
complete -c asusctl -n "cmd_contains_seq aura" -s n -l next-mode -d "Switch to next aura mode"
complete -c asusctl -n "cmd_contains_seq aura" -s p -l prev-mode -d "Switch to previous aura mode"

# aura modes
set -l zones 0 1 one logo lightbar-left lightbar-right
for mode in static breathe rainbow-cycle rainbow-wave pulse
    complete -c asusctl -n "cmd_contains_seq aura $mode" -s c -x -d "RGB color value"
    complete -c asusctl -n "cmd_contains_seq aura $mode" -s z -x -a "$zones" -d "Select zone"
end

# Additional mode-specific options
complete -c asusctl -n "cmd_contains_seq aura breathe" -s C -x -d "Second RGB color value"
complete -c asusctl -n "cmd_contains_seq aura breathe" -s s -x -a "low med high" -d "Set speed"
complete -c asusctl -n "cmd_contains_seq aura rainbow-cycle" -s s -x -a "low med high" -d "Set speed"
complete -c asusctl -n "cmd_contains_seq aura rainbow-wave" -s d -x -a "up down left right" -d "Set direction"
complete -c asusctl -n "cmd_contains_seq aura rainbow-wave" -s s -x -a "low med high" -d "Set speed"

# aura-power subcommand
set -l power_components keyboard logo lightbar lid rear-glow ally
complete -c asusctl -n "cmd_contains_seq aura-power" -f -a "$power_components"
for component in $power_components
    complete -c asusctl -n "cmd_contains_seq aura-power $component" -s b -l boot -x -a "true false" -d "Set boot state"
    complete -c asusctl -n "cmd_contains_seq aura-power $component" -s a -l awake -x -a "true false" -d "Set awake state"
    complete -c asusctl -n "cmd_contains_seq aura-power $component" -s s -l sleep -x -a "true false" -d "Set sleep state"
    complete -c asusctl -n "cmd_contains_seq aura-power $component" -s S -l shutdown -x -a "true false" -d "Set shutdown state"
end

# profile subcommand
set -l profiles Balanced Quiet Performance
complete -c asusctl -n "cmd_contains_seq profile" -s n -l next -d "Toggle next profile"
complete -c asusctl -n "cmd_contains_seq profile" -s l -l list -d "List profiles"
complete -c asusctl -n "cmd_contains_seq profile" -s p -l profile-get -d "Get current profile"
complete -c asusctl -n "cmd_contains_seq profile" -s P -l profile-set -x -a "$profiles" -d "Set active profile"

# fan-curve subcommand
set -l fans cpu gpu mid
complete -c asusctl -n "cmd_contains_seq fan-curve" -s g -l get-enabled -d "Get enabled fan profiles"
complete -c asusctl -n "cmd_contains_seq fan-curve" -s d -l default -d "Reset to default fan curve"
complete -c asusctl -n "cmd_contains_seq fan-curve" -s m -l mod-profile -d "Profile to modify"
complete -c asusctl -n "cmd_contains_seq fan-curve" -s e -l enable-fan-curves -x -a "true false" -d "Enable/disable all curves"
complete -c asusctl -n "cmd_contains_seq fan-curve" -s E -l enable-fan-curve -x -a "true false" -d "Enable/disable single curve"
complete -c asusctl -n "cmd_contains_seq fan-curve" -s f -l fan -x -a "$fans" -d "Select fan to modify"
complete -c asusctl -n "cmd_contains_seq fan-curve" -s D -l data -x -d "Set fan curve data"

# Other subcommands (basic completion)
complete -c asusctl -n "cmd_contains_seq graphics" -f
complete -c asusctl -n "cmd_contains_seq scsi" -f
complete -c asusctl -n "cmd_contains_seq armoury" -f
