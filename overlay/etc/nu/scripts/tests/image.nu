use std/assert
use bf


#======================================================================================================================
# installation
#======================================================================================================================

export def install__unbound_user_has_uid_1000 [] {
    assert equal "1000" (^id -u unbound | str trim)
}

export def install__unbound_matches_build [] {
    let build = with-env {BF_ETC: "/etc/bf"} { bf build | get Unbound }
    let installed = ^unbound -V | parse --regex 'Version (?<v>\d+\.\d+\.\d+)' | get v.0

    assert ($build | str starts-with $installed) $"Unbound ($installed) should match the build ($build)"
}

export def install__unbound_is_not_from_alpine_packages [] {
    # Unbound is compiled separately (bfren-bin/unbound) so it can be newer than Alpine's package
    assert ((^apk info --installed unbound | complete).exit_code != 0) "the Alpine unbound package should not be installed"
}

export def install__unbound_tools_load [] {
    # each tool prints its usage for -h - if a shared library is missing it cannot load at all (exit code 127)
    for x in [unbound-anchor unbound-checkconf unbound-control unbound-host] {
        let result = ^$x -h | complete
        assert ($result.exit_code != 127) $"($x) did not load: ($result.stderr)"
    }
}

export def install__root_hints_are_downloaded [] {
    assert ((open --raw /etc/unbound/root.hints) =~ 'A\.ROOT-SERVERS\.NET\.')
}

export def install__drill_is_installed_for_health_check [] {
    assert (which drill | is-not-empty)
}


#======================================================================================================================
# scripts
#======================================================================================================================

export def scripts__parse [] {
    let paths = [
        "/etc/bf/health.d/10-unbound.nu"
        "/etc/s6-overlay/s6-rc.d/unbound/run"
        "/etc/s6-overlay/s6-rc.d/unbound/finish"
        "/etc/bf/init.d/10-env.nu"
        "/etc/bf/init.d/11-conf.nu"
    ]
    for path in $paths {
        let result = ^$nu.current-exe --no-config-file --commands $"nu-check ($path)" | complete
        assert equal "true" ($result.stdout | str trim) $"($path) does not parse: ($result.stderr)"
    }
}
