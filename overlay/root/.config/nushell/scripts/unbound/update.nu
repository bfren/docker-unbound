use bf

# Check root anchor
export def anchor [] {
    if (bf env check UNBOUND_ENABLE_DNSSEC) {
        bf write debug "Updating root anchor." update/anchor
        s6-setuidgid unbound unbound-anchor -v -a (bf env req UNBOUND_ROOT_KEY)
    } else {
        bf write notok "DNSSEC is disabled." update/anchor
    }
}
