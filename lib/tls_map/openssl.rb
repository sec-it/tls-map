# frozen_string_literal: true

# Ruby internal

# TLS map module
module TLSmap
  # TLS mapping
  class App
    OPENSSL_URL = 'https://raw.githubusercontent.com/openssl/openssl/master/include/openssl/tls1.h'

    def raw_data_openssl
      openssl_h = File.read(@openssl_file.path)

      ck1 = openssl_h.scan(/(TLS1_CK_[a-zA-Z0-9_]+)\s+0x0300([[:xdigit:]]{4})/)
      txt1 = openssl_h.scan(/(TLS1_TXT_[a-zA-Z0-9_]+)\s+"([a-zA-Z0-9-]+)"/)
      ck2 = openssl_h.scan(/(TLS1_3_CK_[a-zA-Z0-9_]+)\s+0x0300([[:xdigit:]]{4})/)
      rfc2 = openssl_h.scan(/(TLS1_3_RFC_[a-zA-Z0-9_]+)\s+"([a-zA-Z0-9_]+)"/)
      { ck1: ck1, txt1: txt1, ck2: ck2, rfc2: rfc2 }
    end

    def clean_raw_data_openssl
      ck1, txt1, ck2, rfc2 = raw_data_openssl.values

      ck1.map! { |e| [e[0][8..], e[1]] }
      txt1.map! { |e| [e[0][9..], e[1]] }
      ck2.map! { |e| [e[0][10..], e[1]] }
      rfc2.map! { |e| [e[0][11..], e[1]] }

      { ck1: ck1, txt1: txt1, ck2: ck2, rfc2: rfc2 }
    end

    def data_openssl
      ck1, txt1, ck2, rfc2 = clean_raw_data_openssl.values
      data = ck1.map { |e| [e[1], txt1.select { |x| x[0] == e[0] }[0][1]] }
      data += ck2.map { |e| [e[1], rfc2.select { |x| x[0] == e[0] }[0][1]] }
      data
    end

    def parse_openssl
      data_openssl.each do |alg|
        @tls_map.each do |h|
          h[:openssl] ||= h[:codepoint] == alg[0].upcase ? alg[1] : nil
        end
      end
    end

    private :parse_openssl, :raw_data_openssl, :clean_raw_data_openssl, :data_openssl
  end
end
