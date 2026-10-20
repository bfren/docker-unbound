use std/assert
use ../bf-unbound/anchor.nu


#======================================================================================================================
# helpers
#======================================================================================================================

# Run anchor update with a stub s6-setuidgid that outputs $output (instead of running unbound-anchor), and $vars set -
# returns the arguments the stub was called with (empty if it wasn't called)
def update_with [output: string, vars: record]: nothing -> list<string> {
    let dir = mktemp --directory
    $"#!/bin/sh\nprintf '%s\\n' \"$@\" > \"$\(dirname \"$0\"\)/args\"\necho '($output)'\nexit 1\n" | save $"($dir)/s6-setuidgid"
    ^chmod +x $"($dir)/s6-setuidgid"
    let path = [$dir] | append ($env.PATH | [$in] | flatten | str join (char esep) | split row (char esep))
    with-env ({PATH: $path} | merge $vars) { anchor update }
    let args = $"($dir)/args"
    if ($args | path exists) { open --raw $args | lines } else { [] }
}


#======================================================================================================================
# update
#======================================================================================================================

export def update__does_nothing_without_dnssec [] {
    assert equal [] (update_with "success: the anchor is ok" {})
}

export def update__runs_unbound_anchor_as_unbound_user [] {
    let args = update_with "success: the anchor is ok" {BF_UNBOUND_ENABLE_DNSSEC: "1", BF_UNBOUND_ROOT_KEY: "/etc/unbound/root.key"}

    assert equal ["unbound" "unbound-anchor" "-v" "-a" "/etc/unbound/root.key"] $args
}

export def update__succeeds_even_when_unbound_anchor_exits_with_an_error [] {
    # unbound-anchor exits with 1 when it creates the anchor file, so its output is checked instead (the stub exits 1)
    update_with "success: the anchor is ok" {BF_UNBOUND_ENABLE_DNSSEC: "1", BF_UNBOUND_ROOT_KEY: "/etc/unbound/root.key"}
}

export def update__fails_when_anchor_is_not_ok [] {
    let vars = {BF_UNBOUND_ENABLE_DNSSEC: "1", BF_UNBOUND_ROOT_KEY: "/etc/unbound/root.key"}

    assert error { update_with "fail: the anchor could not be updated" $vars }
}
