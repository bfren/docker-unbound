use bf
bf env load -x

# Set environment variables
def main [] {
    bf env UNBOUND_CONF "/etc/unbound/unbound.conf"

    if (bf env check UNBOUND_ENABLE_DNSSEC) {
        bf env UNBOUND_ROOT_HINTS "/etc/unbound/root.hints"
        bf env UNBOUND_ROOT_KEY "/etc/unbound/root.key"
    }

    # return nothing
    return
}
