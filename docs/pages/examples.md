# Examples

## CLI

### Search

Search for the IANA value of `RSA_ARCFOUR_128_SHA1` (GnuTLS):

```
$ tls-map search gnutls RSA_ARCFOUR_128_SHA1 -o iana
iana: TLS_RSA_WITH_RC4_128_SHA
```

Search for the IANA value of `AES128-SHA` (OpenSSL):

```
$ tls-map search openssl AES128-SHA -o iana
iana: TLS_RSA_WITH_AES_128_CBC_SHA
```

Search for the hexadecimal codepoint of `TLS_DH_RSA_WITH_AES_256_CBC_SHA-SHA` (IANA):

```
$ tls-map search iana TLS_DH_RSA_WITH_AES_256_CBC_SHA -o codepoint
codepoint: 0037
```

Get all values corresponding to codepoint `1303`:

```
$ tls-map search codepoint 1303
codepoint: 1303
iana: TLS_CHACHA20_POLY1305_SHA256
openssl: TLS_CHACHA20_POLY1305_SHA256
gnutls: CHACHA20_POLY1305_SHA256
nss: TLS_CHACHA20_POLY1305_SHA256
```

Get all values corresponding to NSS cipher algorithm `TLS_AES_256_GCM_SHA384`:

```
$ tls-map search nss TLS_AES_256_GCM_SHA384
codepoint: 1302
iana: TLS_AES_256_GCM_SHA384
openssl: TLS_AES_256_GCM_SHA384
gnutls: AES_256_GCM_SHA384
nss: TLS_AES_256_GCM_SHA384
```

### Export

Export to minified: JSON

```
$ tls-map export /tmp/map.min.json json_compact
/tmp/map.min.json exported
```

### Update

The CLI is working with an offline database (Marshaled Ruby hash) to avoid
fetching and parsing all source file at each execution.
If you want up to date values but do not want to wait for an official new
release of TLS map you can use the update command.
Doing so you will override `data/mapping.marshal` but for security purpose
and integrity check is done so if the file is modified the tool will refuse to
word so you have to use the `--force` option every time to bypass the security
check. So it is recommended to not use the update command and wait for official
release.
