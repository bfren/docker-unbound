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
    # use -i flag to ignore any errors and check value of stdout instead
    let root_key = bf env UNBOUND_ROOT_KEY
    let stdout = { ^s6-setuidgid unbound unbound-anchor -v -a $root_key } | bf handle -i anchor/update

    # on first run unbound-anchor always returns exit code 1 because the anchor file does not exist -
    # even if it goes on to create it successfully
    # therefore instead of checking the exit code we check the output of the command, and write an error
    # if it does not contain the success message
    let success = "success: the anchor is ok"
    if $stdout !~ $success { bf write error $" .. failed with error: ($stdout)." anchor/update }
}
