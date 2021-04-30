# Usage

## CLI

```plaintext
$ tls-map --help
TLS map

Usage:
  tls-map search <critera> <term> [-o <output> --force] [--no-color --debug]
  tls-map export <filename> <format> [--force] [--debug]
  tls-map update [--debug]
  tls-map -h | --help
  tls-map --version

Search options: (offline)
  <critera>               The type of term. Accepted values: codepoint, iana, openssl, gnutls, nss.
  <term>                  The cipher algorithm name.
  -o, --output <output>   Displayed fields. Accepted values: all, codepoint, iana, openssl, gnutls, nss. [default: all]

Export options: (offline)
  <filename>              The output file name to write to.
  <format>                Supported formats: markdown (a markdown table), json_pretty (expanded JSON), json_compact (minified JSON), marshal (Ruby marshalized hash).

Update options: (online) DANGEROUS, will break database integrity, force option will be required

Other options:
  --force     Force parsing even if intigrity check failed (DANGEROUS, may result in command execution vulnerability)
  --no-color  Disable colorized output
  --debug     Display arguments
  -h, --help  Show this screen
  --version   Show version
```

See [Examples](/pages/examples)

## Library

```ruby
require 'tls_map'

tm = TLSmap::App.new

# Translate from one lib to another
tm.search(:gnutls, 'RSA_ARCFOUR_128_SHA1', :iana) #=> {:iana=>"TLS_RSA_WITH_RC4_128_SHA"
tm.search(:openssl, 'AES128-SHA', :iana) #=> {:iana=>"TLS_RSA_WITH_AES_128_CBC_SHA"}
tm.search(:iana, 'TLS_DH_RSA_WITH_AES_256_CBC_SHA', :codepoint) #=> {:codepoint=>"0037"}

# Get all
tm.search(:codepoint, '1303') #=> {:codepoint=>"1303", :iana=>"TLS_CHACHA20_POLY1305_SHA256", :openssl=>"TLS_CHACHA20_POLY1305_SHA256", :gnutls=>"CHACHA20_POLY1305_SHA256", :nss=>"TLS_CHACHA20_POLY1305_SHA256"}
tm.search(:nss, 'TLS_AES_256_GCM_SHA384') #=> {:codepoint=>"1302", :iana=>"TLS_AES_256_GCM_SHA384", :openssl=>"TLS_AES_256_GCM_SHA384", :gnutls=>"AES_256_GCM_SHA384", :nss=>"TLS_AES_256_GCM_SHA384"}
```

See [Examples](/pages/examples) or [the library doc](https://sec-it.github.io/tls-map/yard/TLSmap/App.html)

## Console

Launch `irb` with the library loaded.

```plaintext
$ tls-map_console
irb(main):001:0>
```
