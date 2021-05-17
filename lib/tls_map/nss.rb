# frozen_string_literal: true

# Ruby internal

# TLS map module
module TLSmap
  # TLS mapping
  class App
    # Timeout https://hg.mozilla.org/projects/nss/raw-file/tip/lib/ssl/sslproto.h
    # so use github RO mirror instead.
    NSS_URL = 'https://raw.githubusercontent.com/nss-dev/nss/master/lib/ssl/sslproto.h'

    def parse_nss
      File.read(@nss_file.path).scan(/(TLS_[a-zA-Z0-9_]+)\s+0x([[:xdigit:]]{4})/) do |alg|
        @tls_map.each do |h|
          h[:nss] ||= h[:codepoint] == alg[1].upcase ? alg[0] : nil
        end
      end
    end

    private :parse_nss
  end
end
