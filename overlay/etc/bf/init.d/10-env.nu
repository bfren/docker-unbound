use bf
bf env load

# Set environment variables
def main [] {
    let etc = "/etc/unbound"
    bf env set UNBOUND_ETC $etc
    bf env set UNBOUND_CONF $"($etc)/unbound.conf"

    if (bf env check UNBOUND_ENABLE_DNSSEC) {
        bf env set UNBOUND_ROOT_HINTS $"($etc)/root.hints"
        bf env set UNBOUND_ROOT_KEY $"($etc)/root.key"
    }

    # return nothing
    return
}
