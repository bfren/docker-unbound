use bf

# Update root anchor if DNSSEC is enabled
export def update [] {
    # don't need to update the anchor if DNSSEC is disabled
    if not (bf env check UNBOUND_ENABLE_DNSSEC) {
        bf write notok "DNSSEC is disabled." anchor/update
        return
    }

    bf write debug "Updating root anchor." anchor/update

    # capture output of unbound-anchor executable
    let root_key = bf env UNBOUND_ROOT_KEY
    let result = do { ^s6-setuidgid unbound unbound-anchor -v -a $root_key } | complete
    if $result.stdout !~ success { bf write error $" .. failed with error: ($result.stdout)." anchor/update }
}
