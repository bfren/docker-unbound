use bf

# Check root anchor
export def anchor [] {
    # don't need to update the anchor if DNSSEC is disabled
    if not (bf env check UNBOUND_ENABLE_DNSSEC) {
        bf write notok "DNSSEC is disabled." update/anchor
        return
    }

    bf write debug "Updating root anchor." update/anchor

    # capture output of unbound-anchor executable
    let result = do { s6-setuidgid unbound unbound-anchor -v -a (bf env req UNBOUND_ROOT_KEY) } | complete
    if not (bf env req UNBOUND_ROOT_KEY | path exists) {
        $result | print
        bf write error --code $result.exit_code " .. failed."
    }
}
