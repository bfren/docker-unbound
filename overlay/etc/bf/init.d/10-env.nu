use bf
use bf-s6
bf-s6 env set_executable

# Set environment variables
def main [] {
    bf-s6 env UNBOUND_CONF "/etc/unbound/unbound.conf"

    if (bf env check UNBOUND_ENABLE_DNSSEC) {
        bf-s6 env UNBOUND_ROOT_HINTS "/etc/unbound/root.hints"
        bf-s6 env UNBOUND_ROOT_KEY "/etc/unbound/root.key"
    }

    # return nothing
    return
}
