use bf
bf env load

# Generate Unbound configuration file and apply permissions
def main [] {
    bf write "Generating Unbound configuration."
    bf esh template (bf env UNBOUND_CONF)
    bf ch apply_file "10-unbound"
}
