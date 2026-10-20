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
