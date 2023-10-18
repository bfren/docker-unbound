use bf
use s6
s6 env set_executable

# Set environment variables
def main [] {
    s6 env UNBOUND_CONF "/etc/unbound/unbound.conf"

    if (bf env check UNBOUND_ENABLE_DNSSEC) {
        s6 env UNBOUND_ROOT_HINTS "/etc/unbound/root.hints"
        s6 env UNBOUND_ROOT_KEY "/etc/unbound/root.key"
    }

    # return nothing
    return
}
