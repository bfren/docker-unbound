use bf
bf env load

# Set environment variables
def main [] {
    bf env set UNBOUND_CONF "/etc/unbound/unbound.conf"

    if (bf env check UNBOUND_ENABLE_DNSSEC) {
        bf env set UNBOUND_ROOT_HINTS "/etc/unbound/root.hints"
        bf env set UNBOUND_ROOT_KEY "/etc/unbound/root.key"
    }

    # return nothing
    return
}
