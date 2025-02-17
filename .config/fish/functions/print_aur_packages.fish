function print_aur_packages
    # Caches for 5 minutes
    type -q -f paru || return 1

    set -l xdg_cache_home (__fish_make_cache_dir)
    or return

    set -l cache_file $xdg_cache_home/.paru-cache.$USER
    if test -f $cache_file
        cat $cache_file
        set -l age (path mtime -R -- $cache_file)
        set -l max_age 250
        if test $age -lt $max_age
            return
        end
    end
    # prints: <package name>	Package
    paru -Slaq | sed -e 's/$/\t''AUR Package''/' >$cache_file &
    return 0
end
