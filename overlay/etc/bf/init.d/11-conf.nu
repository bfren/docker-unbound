use bf
bf env load

# Generate Unbound configuration file and apply permissions
def main [] {
    bf write "Generating Unbound configuration."
    bf esh $"(bf env TEMPLATES)/unbound.conf.esh" (bf env UNBOUND_CONF)
    bf ch apply_file $"(bf env CH_D)/10-unbound"
}
