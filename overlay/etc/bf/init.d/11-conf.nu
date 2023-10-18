use bf
use s6
s6 env set_executable

# Generate Unbound configuration file and apply permissions
def main [] {
    bf esh $"(bf env req TEMPLATES)/unbound.conf.esh" (bf env req UNBOUND_CONF)
    bf ch apply $"(bf env req CH_D)/10-unbound"
}
