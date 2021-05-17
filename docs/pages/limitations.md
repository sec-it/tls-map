# Limitations

TLS map is only taking into account the TLS protocol. This means it will list
ciphers of TLS 1.0, TLS 1.1, TLS 1.2 and TLS 1.3 but not from SSL 2.0 and SSL
3.0.

Some TLS libraries are using some custom cipher suites that are not
included the TLS standard, those non-standard algorithm are not supported by
TLS map.
