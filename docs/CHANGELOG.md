# Changelog

## [Unreleased]

## [1.2.0]

Additions:

- New `TLSmap::App::Extractor` class: extract ciphers from external tools file output (see [lib doc](https://sec-it.github.io/tls-map/yard/TLSmap/App/Extractor))
  - Support SSLyze, sslscan2, testssl.sh, ssllabs-scan
  - New `extract` CLI command

Documentation:

- Change yard doc format from rdoc to markdown

Quality:

- Create unit tests

## [1.1.0]

Additions:

- New `TLSmap::App::Extended` class: partial wrapper around ciphersuite.info API to get extra info about a cipher
- New `--extended` and `--acronym` CLI option for the `search` command using the new class

Changes:

- Move `tmpfile()` to a `Utils` module (no breaking changes)

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
