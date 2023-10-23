use bf

# Check Unbound configuration
export def check [] {
    bf write debug "Checking Unbound configuration." conf/check

    # capture output of unbound-checkconf executable
    let result = do { ^bf-x-as unbound-checkconf (bf env UNBOUND_CONF) } | complete
    if $result.exit_code > 0 { $result | into string | bf write error --code $result.exit_code $in conf/check }
}
