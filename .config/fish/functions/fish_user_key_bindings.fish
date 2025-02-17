function fish_user_key_bindings
    fish_vi_key_bindings

    # Bind jk to escape from insert mode
    set -g fish_sequence_key_delay_ms 100
    bind -M insert jk "if commandline -P; commandline -f cancel; else; set fish_bind_mode default; commandline -f backward-char force-repaint; end"

    # Bind ctrl-k to accept autosuggestions
    bind -M insert \ck 'commandline -f accept-autosuggestion'

    # hjkl movement fix for pager
    bind -M insert j 'commandline -P; and down-or-search; or commandline -i j'
    bind -M insert k 'commandline -P; and up-or-search; or commandline -i k'
    bind -M insert h 'commandline -P; and commandline -f backward-char; or commandline -i h'
    bind -M insert l 'commandline -P; and commandline -f forward-char; or commandline -i l'

    # Use emacs keybindings for history while in insert mode
    bind -M insert \cr history-pager
    bind -M insert \cn up-or-search
    bind -M insert \cp down-or-search
end
