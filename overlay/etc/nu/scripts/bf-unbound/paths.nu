# Return the paths used to configure Unbound - the root key (used to validate DNSSEC) is only set if DNSSEC is enabled
export def main [
    --dnssec    # Whether or not DNSSEC is enabled
]: nothing -> record {
    let etc = "/etc/unbound"
    {
        etc: $etc
        conf: $"($etc)/unbound.conf"
        root_hints: $"($etc)/root.hints"
        root_key: (if $dnssec { $"($etc)/root.key" } else { "" })
    }
}
