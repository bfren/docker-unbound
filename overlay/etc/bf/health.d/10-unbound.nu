use bf
bf env load -x

# Attempt to resolve cloudflare.com using the local server
def main [] {
    if ({ ^drill cloudflare.com @127.0.0.1 } | bf handle -c) != 0 { exit 1 }
}
