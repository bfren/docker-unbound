use std/assert
use bf-unbound


#======================================================================================================================
# helpers
#======================================================================================================================

# Generate unbound.conf from the template in a temporary directory, with the environment set the way 10-env.nu sets it
# plus $vars, and return its lines without comments or blank lines
def render [vars: record = {}]: nothing -> list<string> {
    let file = $"(mktemp --directory)/unbound.conf"
    let dnssec = ($vars | get --optional BF_UNBOUND_ENABLE_DNSSEC | default "0") == "1"
    let paths = bf-unbound paths --dnssec=$dnssec
    let path_vars = {BF_UNBOUND_ROOT_HINTS: $paths.root_hints, BF_UNBOUND_ROOT_KEY: $paths.root_key}
        | transpose key value
        | where value != ""
        | transpose -r -d
    let result = with-env ($path_vars | merge $vars) { ^esh -o $file /etc/bf/templates/unbound.conf.esh | complete }
    assert equal 0 $result.exit_code $"the template should render: ($result.stderr)"
    open --raw $file | lines | str trim | where {|x| $x != "" and not ($x starts-with "#") }
}


#======================================================================================================================
# paths
#======================================================================================================================

export def paths__set_root_key_only_with_dnssec [] {
    assert equal "" (bf-unbound paths).root_key
    assert equal "/etc/unbound/root.key" (bf-unbound paths --dnssec).root_key
}

export def paths__always_set_root_hints [] {
    assert equal "/etc/unbound/root.hints" (bf-unbound paths).root_hints
    assert equal "/etc/unbound/root.hints" (bf-unbound paths --dnssec).root_hints
}


#======================================================================================================================
# unbound.conf
#======================================================================================================================

export def template__renders_without_dnssec [] {
    # DNSSEC is off by default, and the template must still render without the root key
    let conf = render

    assert ("root-hints: \"/etc/unbound/root.hints\"" in $conf)
    assert ($conf | where {|x| $x starts-with "auto-trust-anchor-file" } | is-empty) "the root key should not be used"
    assert ($conf | where {|x| $x =~ "Unable to get" } | is-empty) "no errors should be written to the configuration"
}

export def template__uses_root_key_with_dnssec [] {
    let conf = render {BF_UNBOUND_ENABLE_DNSSEC: "1"}

    assert ("auto-trust-anchor-file: \"/etc/unbound/root.key\"" in $conf)
}

export def template__listens_on_port_53_for_all_ipv4_addresses [] {
    let conf = render

    for x in ["interface: 0.0.0.0" "port: 53" "interface-action: 0.0.0.0 allow" "username: \"unbound\""] {
        assert ($x in $conf) $"($x) should be set"
    }
}

export def template__uses_defaults [] {
    let conf = render

    for x in ["verbosity: 1" "num-threads: 1" "cache-min-ttl: 0" "cache-max-ttl: 86400" "prefetch: no" "hide-version: no" "qname-minimisation: yes"] {
        assert ($x in $conf) $"($x) should be set"
    }
}

export def template__uses_settings [] {
    let conf = render {
        BF_UNBOUND_VERBOSITY: "2"
        BF_UNBOUND_NUM_THREADS: "4"
        BF_UNBOUND_CACHE_MIN_TTL: "3600"
        BF_UNBOUND_PREFETCH: "yes"
        BF_UNBOUND_HIDE_VERSION: "yes"
    }

    for x in ["verbosity: 2" "num-threads: 4" "cache-min-ttl: 3600" "prefetch: yes" "hide-version: yes"] {
        assert ($x in $conf) $"($x) should be set"
    }
}

export def template__adds_private_addresses_only_when_enabled [] {
    let private = "private-address: 192.168.0.0/16"

    assert not ($private in (render))
    assert ($private in (render {BF_UNBOUND_PRIVATE_ADDRESS_ENABLE: "1"}))
}

export def template__disables_remote_control [] {
    assert ("control-enable: no" in (render))
}
