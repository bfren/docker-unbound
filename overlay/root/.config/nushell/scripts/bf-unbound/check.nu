use bf

# Check Unbound configuration
export def conf [] {
    bf write debug "Checking Unbound configuration." conf/check
    let result = s6-setuidgid unbound unbound-checkconf (bf env req UNBOUND_CONF) | complete
    if $result.exit_code > 0 {
        bf write error "Error checking Unbound configuration." conf/check
        $result | print
        exit $result.exit_code
    }
}
