# frozen_string_literal: true

# Ruby internal

# TLS map module
module TLSmap
  # TLS mapping
  class App
    GNUTLS_URL = 'https://gitlab.com/gnutls/gnutls/raw/master/lib/algorithms/ciphersuites.c'

    def parse_gnutls
      reg = /(GNUTLS_[a-zA-Z0-9_]+)\s+{\s?(0x[[:xdigit:]]{2},\s?0x[[:xdigit:]]{2})\s?}/
      File.read(@gnutls_file.path).scan(reg).each do |alg|
        codepoint = codepoint_iana(alg[1])
        name = alg[0][7..]
        @tls_map.each do |h|
          h[:gnutls] ||= h[:codepoint] == codepoint.upcase ? name : nil
        end
      end
    end

    private :parse_gnutls
  end
end
