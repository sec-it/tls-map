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

Display extended information (online):

```
$ tls-map search -e codepoint 0013
codepoint: 0013
iana: TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA
openssl: DHE-DSS-DES-CBC3-SHA
gnutls: DHE_DSS_3DES_EDE_CBC_SHA1
nss: TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA
Protocol: TLS
Key Exchange: DHE
Authentication: DSS
Encryption: 3DES EDE CBC
Hash: SHA
Security: weak
TLS Version(s): TLS1.0, TLS1.1
Vulnerabilities:
  - Medium - While Triple-DES is still recognized as a secure symmetric-key encryption, a more and more standardizations bodies and projects decide to deprecate this algorithm. Though not broken, it has been proven to suffer from several vulnerabilities in the past (see [sweet32.info](https://sweet32.info)).
  - Medium - In 2013, researchers demonstrated a timing attack against several TLS implementations using the CBC encryption algorithm (see [isg.rhul.ac.uk](http://www.isg.rhul.ac.uk/tls/Lucky13.html)). Additionally, the CBC mode is vulnerable to plain-text attacks in TLS 1.0, SSL 3.0 and lower. A fix has been introduced with TLS 1.2 in form of the GCM mode which is not vulnerable to the BEAST attack. GCM should be preferred over CBC.
  - Medium - The Secure Hash Algorithm 1 has been proven to be insecure as of 2017 (see [shattered.io](https://shattered.io)).
More info: https://ciphersuite.info/cs/TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA/
```

Display extended information (online) with full acronym name:

```
$ tls-map search -e codepoint 0013 -a
codepoint: 0013
iana: TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA
openssl: DHE-DSS-DES-CBC3-SHA
gnutls: DHE_DSS_3DES_EDE_CBC_SHA1
nss: TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA
Protocol: TLS (Transport Layer Security)
Key Exchange: DHE (Diffie-Hellman Ephemeral)
Authentication: DSS (Digital Signature Standard)
Encryption: 3DES EDE CBC (Triple-DES (Encrypt Decrypt Encrypt) in Cipher Block Chaining mode)
Hash: SHA (Secure Hash Algorithm 1)
Security: weak
TLS Version(s): TLS1.0, TLS1.1
Vulnerabilities:
  - Medium - While Triple-DES is still recognized as a secure symmetric-key encryption, a more and more standardizations bodies and projects decide to deprecate this algorithm. Though not broken, it has been proven to suffer from several vulnerabilities in the past (see [sweet32.info](https://sweet32.info)).
  - Medium - In 2013, researchers demonstrated a timing attack against several TLS implementations using the CBC encryption algorithm (see [isg.rhul.ac.uk](http://www.isg.rhul.ac.uk/tls/Lucky13.html)). Additionally, the CBC mode is vulnerable to plain-text attacks in TLS 1.0, SSL 3.0 and lower. A fix has been introduced with TLS 1.2 in form of the GCM mode which is not vulnerable to the BEAST attack. GCM should be preferred over CBC.
  - Medium - The Secure Hash Algorithm 1 has been proven to be insecure as of 2017 (see [shattered.io](https://shattered.io)).
More info: https://ciphersuite.info/cs/TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA/
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
