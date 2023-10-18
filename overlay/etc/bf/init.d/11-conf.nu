use bf
bf env load -e

# Generate Unbound configuration file and apply permissions
def main [] {
    bf write "Generating Unbound configuration."
    bf esh $"(bf env req TEMPLATES)/unbound.conf.esh" (bf env req UNBOUND_CONF)
    bf ch apply $"(bf env req CH_D)/10-unbound"
}
