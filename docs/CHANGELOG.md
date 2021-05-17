## [Unreleased]

## [1.1.0]

Fix:

  - fix NSS and GnuTLS parser: many ciphers were not parsed due to a wrong regexp
  - make search case-insensitive for hexadecimal codepoints
  - fix OpenSSL parser: some TLS 1.0 ciphers where defined in SSL 3.0 source code file

Documentation:

- Added a _limitations_ page
  - No SSL support
  - No custom cipher suites support
  - Unassigned and reserved codepoints are hidden

## [1.0.0]

- First version
