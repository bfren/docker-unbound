use bf

# Check root anchor
export def anchor [] {
    if (bf env check UNBOUND_ENABLE_DNSSEC) {
        bf write debug "Updating root anchor." update/anchor
        let result = s6-setuidgid unbound unbound-anchor -v -a (bf env req UNBOUND_ROOT_KEY) | complete
        if not (bf env req UNBOUND_ROOT_KEY | path exists) {
            bf write notok "Error updating root anchor." update/anchor
            $result | print
            exit $result.exit_code
        }
    } else {
        bf write notok "DNSSEC is disabled." update/anchor
    }
}
