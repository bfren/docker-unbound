use std/assert
use bf-unbound


#======================================================================================================================
# helpers
#======================================================================================================================

# Generate unbound.conf from the template in a temporary directory, with the environment set the way the Dockerfile
# and 10-env.nu set it plus $vars, and return its lines without comments or blank lines
def render [vars: record = {}]: nothing -> list<string> {
    let file = $"(mktemp --directory)/unbound.conf"
    let vars = {BF_UNBOUND_ENABLE_DNSSEC: "1"} | merge $vars
    let dnssec = $vars.BF_UNBOUND_ENABLE_DNSSEC == "1"
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
    # the template must still render without the root key when DNSSEC is disabled
    let conf = render {BF_UNBOUND_ENABLE_DNSSEC: "0"}

    assert ("root-hints: \"/etc/unbound/root.hints\"" in $conf)
    assert ($conf | where {|x| $x starts-with "auto-trust-anchor-file" } | is-empty) "the root key should not be used"
    assert ($conf | where {|x| $x =~ "Unable to get" } | is-empty) "no errors should be written to the configuration"
}

export def template__uses_root_key_with_dnssec_by_default [] {
    let conf = render

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

    let expected = [
        "verbosity: 1" "num-threads: 1" "cache-min-ttl: 0" "cache-max-ttl: 86400" "prefetch: no" "qname-minimisation: yes"
        "serve-expired: no" "log-servfail: no" "val-log-level: 1" "answer-cookie: no"
    ]
    for x in $expected {
        assert ($x in $conf) $"($x) should be set"
    }
}

export def template__uses_settings [] {
    let conf = render {
        BF_UNBOUND_VERBOSITY: "2"
        BF_UNBOUND_NUM_THREADS: "4"
        BF_UNBOUND_CACHE_MIN_TTL: "3600"
        BF_UNBOUND_PREFETCH: "yes"
        BF_UNBOUND_HIDE_VERSION: "no"
        BF_UNBOUND_SERVE_EXPIRED: "yes"
        BF_UNBOUND_ANSWER_COOKIE: "yes"
        BF_UNBOUND_HARDEN_DNSSEC_STRIPPED: "no"
        BF_UNBOUND_ITER_SCRUB_PROMISCUOUS: "no"
    }

    let expected = [
        "verbosity: 2" "num-threads: 4" "cache-min-ttl: 3600" "prefetch: yes" "hide-version: no" "serve-expired: yes"
        "answer-cookie: yes" "harden-dnssec-stripped: no" "iter-scrub-promiscuous: no"
    ]
    for x in $expected {
        assert ($x in $conf) $"($x) should be set"
    }
}

export def template__uses_hardened_defaults [] {
    let conf = render

    let expected = [
        "harden-dnssec-stripped: yes" "harden-below-nxdomain: yes" "hide-identity: yes" "hide-version: yes" "deny-any: yes"
    ]
    for x in $expected {
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
