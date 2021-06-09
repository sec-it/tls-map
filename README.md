# TLS map

[![Gem Version](https://badge.fury.io/rb/tls-map.svg)](https://badge.fury.io/rb/tls-map)
![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/sec-it/tls-map)
[![GitHub forks](https://img.shields.io/github/forks/sec-it/tls-map)](https://github.com/sec-it/tls-map/network)
[![GitHub stars](https://img.shields.io/github/stars/sec-it/tls-map)](https://github.com/sec-it/tls-map/stargazers)
[![GitHub license](https://img.shields.io/github/license/sec-it/tls-map)](https://github.com/sec-it/tls-map/blob/master/LICENSE.txt)
[![Rawsec's CyberSecurity Inventory](https://inventory.rawsec.ml/img/badges/Rawsec-inventoried-FF5050_flat.svg)](https://inventory.rawsec.ml/tools.html#TLS%20map)

[![Packaging status](https://repology.org/badge/vertical-allrepos/tls-map.svg)](https://repology.org/project/tls-map/versions)

![logo](docs/_media/logo.png)

> CLI & library for mapping TLS cipher algorithm names: IANA, OpenSSL, GnuTLS, NSS

**CLI**

[![asciicast](https://asciinema.org/a/410877.svg)](https://asciinema.org/a/410877)

**Library**

![library example](https://i.imgur.com/3KZgZ6b.png)

## Features

- CLI and library
- Search feature: hexadecimal codepoint and major TLS libraries cipher algorithm name: IANA, OpenSSL, GnuTLS, NSS
  - get extra info about a cipher
- Export to files: markdown table, expanded JSON, minified JSON, Ruby marshalized hash
- Extract ciphers from external tools file output (SSLyze, sslscan2, testssl.sh, ssllabs-scan)
- Bulk search (file with one cipher per line)

## Installation

```plaintext
$ gem install tls-map
```

Check the [installation](https://sec-it.github.io/tls-map/#/pages/install) page on the documentation to discover more methods.

## Documentation

Homepage / Documentation: https://sec-it.github.io/tls-map/

## Author

Made by Alexandre ZANNI ([@noraj](https://pwn.by/noraj/)), pentester at [SEC-IT](https://sec-it.fr).
