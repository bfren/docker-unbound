use bf

# Check Unbound configuration
export def check [] {
    bf write debug "Checking Unbound configuration." conf/check

    # capture output of unbound-checkconf executable
    { ^bf-x-as unbound unbound-checkconf (bf env UNBOUND_CONF) } | bf handle conf/check
}
