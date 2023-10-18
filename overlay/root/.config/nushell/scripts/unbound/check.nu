use bf

# Check Unbound configuration
export def conf [] {
    bf write debug "Checking Unbound configuration." conf/check
    s6-setuidgid unbound unbound-checkconf (bf env req UNBOUND_CONF)
}
