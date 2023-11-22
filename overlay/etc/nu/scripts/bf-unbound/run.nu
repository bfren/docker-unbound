use bf
use anchor.nu
use conf.nu

# Run preflight checks before executing process
export def preflight [] {
    # load environment
    bf env load

    # manually set executing script
    bf env x_set --override run unbound

    # update root anchor and verify configuration
    anchor update
    conf check

    # if we get here we are ready to start Unbound
    bf write "Starting Unbound in daemon mode."
}
