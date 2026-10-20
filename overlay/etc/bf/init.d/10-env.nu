use bf
use bf-unbound
bf env load

# Set environment variables
def main [] {
    let paths = bf-unbound paths --dnssec=(bf env check UNBOUND_ENABLE_DNSSEC)
    bf env set UNBOUND_ETC $paths.etc
    bf env set UNBOUND_CONF $paths.conf

    # root hints are always used - the root key is only set (and so only used) when DNSSEC is enabled
    bf env set UNBOUND_ROOT_HINTS $paths.root_hints
    bf env set UNBOUND_ROOT_KEY $paths.root_key

    # return nothing
    return
}
