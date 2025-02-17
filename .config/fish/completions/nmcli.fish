function __nmcli_get_connections
    set -l connections
    for i in (nmcli -g NAME,TYPE connection show 2>/dev/null)
        set -l modified (string replace -r ':' '\t' $i)
        set -a connections "'$modified'"
    end
    echo $connections
end

function __nmcli_get_ssid
    nmcli -g SSID device wifi list 2>/dev/null
end

function __nmcli_get_bssid
    nmcli -g BSSID device wifi list 2>/dev/null | string replace --all \\\ ""
end

function cmd_contains_seq --description 'Return true if the commandline ends with the given sequence'
    set -l pattern (string join ' ' $argv)
    set pattern (string join '' $pattern '\s*?[\w-]*?$')
    set -l cmd (commandline -p)
    string match -r $pattern $cmd
end


set -l cname (__nmcli_get_connections)
set -l devices (nmcli -g DEVICE device status 2>/dev/null)
set -l wifi_devices (nmcli -t -f DEVICE,TYPE device status | string match '*:wifi' | string replace ':wifi' '')
set -l available_con_types 6lowpan olpc-mesh wifi ethernet adsl bluetooth bond bridge cdma dummy generic gsm hsr infiniband ip-tunnel loopback macsec macvlan ovs-bridge ovs-dpdk ovs-interface ovs-patch ovs-port pppoe team tun veth vlan vpn vrf vxlan wifi-p2p wimax wireguard wpan bond-slave bridge-slave team-slave
set -l available_vpn_types iodine libreswan openswan pptp vpnc l2tp openconnect openvpn ssh wireguard

set -l nmcli_commands general networking radio connection device agent monitor help
set -l nmcli_general status hostname permissions logging help
set -l nmcli_networking on off connectivity help
set -l nmcli_radio all wifi wwan help
set -l nmcli_connection show up down add modify clone edit delete monitor reload load import export help
set -l nmcli_device status show set connect reapply modify disconnect delete monitor wifi lldp help
set -l nmcli_agent secret polkit all help

complete -c nmcli -s t -l terse -d 'Output is terse' -n "not __fish_seen_subcommand_from $nmcli_commands"
complete -c nmcli -s p -l pretty -d 'Output is pretty' -n "not __fish_seen_subcommand_from $nmcli_commands"
complete -c nmcli -s m -l mode -d 'Switch between tabular and multiline mode' -xa 'tabular multiline' -n "not __fish_seen_subcommand_from $nmcli_commands"
complete -c nmcli -s c -l color -d 'Whether to use colors in output' -xa 'auto yes no' -n "not __fish_seen_subcommand_from $nmcli_commands"
complete -c nmcli -s f -l fields -d 'Specify the output fields' -xa 'all common' -n "not __fish_seen_subcommand_from $nmcli_commands"
complete -c nmcli -s e -l escape -d 'Whether to escape ":" and "\\" characters' -xa 'yes no' -n "not __fish_seen_subcommand_from $nmcli_commands"
complete -c nmcli -s a -l ask -d 'Ask for missing parameters' -n "not __fish_seen_subcommand_from $nmcli_commands"
complete -c nmcli -s s -l show-secrets -d 'Allow displaying passwords' -n "not __fish_seen_subcommand_from $nmcli_commands"
complete -c nmcli -s w -l wait -d 'Set timeout (seconds) waiting for finishing operations' -x -n "not __fish_seen_subcommand_from $nmcli_commands"
complete -c nmcli -s v -l version -d 'Show nmcli version' -x -n "not __fish_seen_subcommand_from $nmcli_commands"
complete -c nmcli -s h -l help -d 'Print help information' -x
complete -c nmcli -d 'Command-line tool to control NetworkManager'

complete -c nmcli -n "not __fish_seen_subcommand_from $nmcli_commands" -xa "$nmcli_commands"

complete -c nmcli -n "cmd_contains_seq general" -xa status -d 'Show overall status of NetworkManager'
complete -c nmcli -n "cmd_contains_seq general" -xa hostname -d 'Get or change persistent system hostname'
complete -c nmcli -n "cmd_contains_seq general" -xa permissions -d 'Show caller permissions for authenticated operations'
complete -c nmcli -n "cmd_contains_seq general" -xa logging -d 'Get or change NetworkManager logging level and domains'
complete -c nmcli -n "cmd_contains_seq general" -xa help
complete -c nmcli -n "cmd_contains_seq general logging" -xa 'level domains help'

complete -c nmcli -n "cmd_contains_seq networking" -xa on -d 'Switch networking on'
complete -c nmcli -n "cmd_contains_seq networking" -xa off -d 'Switch networking off'
complete -c nmcli -n "cmd_contains_seq networking" -xa connectivity -d 'Get network connectivity state'
complete -c nmcli -n "cmd_contains_seq networking" -xa help
complete -c nmcli -n "cmd_contains_seq networking connectivity" -xa check -d 'Re-check the connectivity'

complete -c nmcli -n "cmd_contains_seq radio" -xa all -d 'Get status of all radio switches; turn them on/off'
complete -c nmcli -n "cmd_contains_seq radio all" -xa 'on off help'
complete -c nmcli -n "cmd_contains_seq radio" -xa wifi -d 'Get status of Wi-Fi radio switch; turn it on/off'
complete -c nmcli -n "cmd_contains_seq radio wifi" -xa 'on off help'
complete -c nmcli -n "cmd_contains_seq radio" -xa wwan -d 'Get status of mobile broadband radio switch; turn it on/off'
complete -c nmcli -n "cmd_contains_seq radio wwan" -xa 'on off help'

complete -c nmcli -n "cmd_contains_seq connection" -xa "$nmcli_connection" -k
# Connection subcommands are self-explanatory, I'm just highlighting a difference between edit and modify
complete -c nmcli -n "cmd_contains_seq connection" -xa modify -d "Modify one or more properties"
complete -c nmcli -n "cmd_contains_seq connection" -xa edit -d "Interactive edit"
complete -c nmcli -n "cmd_contains_seq connection show" -l active -d 'List only active profiles'
complete -c nmcli -n "cmd_contains_seq connection show" -l order -d 'Custom connection ordering'
complete -c nmcli -n "cmd_contains_seq connection show" -xa "help $cname" -k
complete -c nmcli -n "cmd_contains_seq connection up" -xa "help $cname" -k
complete -c nmcli -n "cmd_contains_seq connection up" -xa "$devices" -k
complete -c nmcli -n "cmd_contains_seq connection up" -xa "(__nmcli_get_bssid)"
complete -c nmcli -n "cmd_contains_seq connection up" -xa nsp -d 'Specify NSP to connect to (only for WiMAX)'
complete -c nmcli -n "cmd_contains_seq connection up" -xa passwd-file -d 'password file to activate the connection'
complete -c nmcli -n "cmd_contains_seq connection down" -xa "help $cname" -k
complete -c nmcli -n "cmd_contains_seq connection add" -xa 'type ifname con-name autoconnect save master slave-type help'
complete -c nmcli -n "cmd_contains_seq connection add" -xa "$devices"
complete -c nmcli -n "cmd_contains_seq connection modify" -l temporary
complete -c nmcli -n "cmd_contains_seq connection modify" -xa "help $cname" -k
complete -c nmcli -n "cmd_contains_seq connection clone" -l temporary
complete -c nmcli -n "cmd_contains_seq connection clone" -xa "help $cname" -k
complete -c nmcli -n "cmd_contains_seq connection edit" -xa "type help $cname" -k
complete -c nmcli -n "cmd_contains_seq connection edit type" -xa "$available_con_types"
complete -c nmcli -n "cmd_contains_seq connection delete" -xa "help $cname" -k
complete -c nmcli -n "cmd_contains_seq connection monitor" -xa "help $cname" -k
complete -c nmcli -n "cmd_contains_seq connection import" -l temporary
complete -c nmcli -n "cmd_contains_seq connection import" -xa type

# Completions for `connection import type` and `connection import type $import_type file`
complete -c nmcli -n "cmd_contains_seq connection import type" -xa "$available_vpn_types"
for import_type in $available_vpn_types
    complete -c nmcli -n "cmd_contains_seq connection import type $import_type" -xa file
end

complete -c nmcli -n "cmd_contains_seq connection export" -xa "help $cname" -k

set -l wifi_commands list connect hotspot rescan help
complete -c nmcli -n "cmd_contains_seq device" -xa "$nmcli_device"
complete -c nmcli -n "cmd_contains_seq device set" -xa 'ifname autoconnect managed'
complete -c nmcli -n "cmd_contains_seq device wifi" -xa "$wifi_commands"
complete -c nmcli -n "cmd_contains_seq device wifi list" -xa 'ifname bssid'
complete -c nmcli -n "cmd_contains_seq device wifi list ifname" -xa "$wifi_devices"
complete -c nmcli -n "cmd_contains_seq device wifi list bssid" -xa "(__nmcli_get_bssid)"
complete -c nmcli -n "cmd_contains_seq device wifi connect" -xa "(__nmcli_get_ssid) (__nmcli_get_bssid) password wep-key-type ifname bssid name private hidden" -k
complete -c nmcli -n "cmd_contains_seq device wifi connect ifname" -xa "$wifi_devices"
complete -c nmcli -n "cmd_contains_seq device wifi connect bssid" -xa "(__nmcli_get_bssid)"
complete -c nmcli -n "cmd_contains_seq device wifi hotspot" -xa 'ifname con-name ssid band channel password'
complete -c nmcli -n "cmd_contains_seq device wifi hotspot ifname" -xa "$wifi_devices"
complete -c nmcli -n "cmd_contains_seq device wifi rescan" -xa 'ifname ssid'
complete -c nmcli -n "cmd_contains_seq device wifi rescan ifname" -xa "$wifi_devices"
complete -c nmcli -n "cmd_contains_seq device wifi rescan ssid" -xa "(__nmcli_get_ssid)"
complete -c nmcli -n "cmd_contains_seq device lldp" -xa list

complete -c nmcli -n "cmd_contains_seq agent" -xa secret -d "Register nmcli as NM secret agent"
complete -c nmcli -n "cmd_contains_seq agent" -xa polkit -d "Register nmcli as a polkit agent for user session"
complete -c nmcli -n "cmd_contains_seq agent" -xa all -d "Run nmcli as secret and polkit agent"
