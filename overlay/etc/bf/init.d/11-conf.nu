use bf
use bf-s6
bf env load

# Generate Unbound configuration file and apply permissions
def main [] {
    bf write "Generating Unbound configuration."
    bf-s6 esh template (bf env UNBOUND_CONF)
    bf-s6 ch apply_file "10-unbound"
}
