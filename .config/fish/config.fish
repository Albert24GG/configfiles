if status is-interactive
    # Commands to run in interactive sessions can go here

    # Enable man pages coloring
    set -xU MANPAGER 'less -R --use-color -Dd+r -Du+b'
    set -xU MANROFFOPT '-P -c'

    # Disable the greeting
    set -U fish_greeting

    # Set the editor
    set -xU EDITOR nvim
    set -xU SUDO_EDITOR nvim
end
