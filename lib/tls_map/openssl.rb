# frozen_string_literal: true

# Ruby internal

# TLS map module
module TLSmap
  # TLS mapping
  class App
    OPENSSL_URL = 'https://raw.githubusercontent.com/openssl/openssl/master/include/openssl/tls1.h'
    OPENSSL_URL2 = 'https://raw.githubusercontent.com/openssl/openssl/master/include/openssl/ssl3.h'

    def raw_data_openssl
      openssl_h = File.read(@openssl_file.path)
      openssl_h2 = File.read(@openssl_file2.path)

      ck1 = openssl_h.scan(/(TLS1_CK_[a-zA-Z0-9_]+)\s+0x0300([[:xdigit:]]{4})/)
      txt1 = openssl_h.scan(/(TLS1_TXT_[a-zA-Z0-9_]+)\s+"([a-zA-Z0-9-]+)"/)
      ck2 = openssl_h.scan(/(TLS1_3_CK_[a-zA-Z0-9_]+)\s+0x0300([[:xdigit:]]{4})/)
      rfc2 = openssl_h.scan(/(TLS1_3_RFC_[a-zA-Z0-9_]+)\s+"([a-zA-Z0-9_]+)"/)
      ck3 = openssl_h2.scan(/(SSL3_CK_[a-zA-Z0-9_]+)\s+0x0300([[:xdigit:]]{4})/)
      txt3 = openssl_h2.scan(/(SSL3_TXT_[a-zA-Z0-9_]+)\s+"([a-zA-Z0-9-]+)"/)
      { ck1: ck1, txt1: txt1, ck2: ck2, rfc2: rfc2, ck3: ck3, txt3: txt3 }
    end

    def clean_raw_data_openssl
      ck1, txt1, ck2, rfc2, ck3, txt3 = raw_data_openssl.values

      ck1.map! { |e| [e[0][8..], e[1]] }
      txt1.map! { |e| [e[0][9..], e[1]] }
      ck2.map! { |e| [e[0][10..], e[1]] }
      rfc2.map! { |e| [e[0][11..], e[1]] }
      ck3.map! { |e| [e[0][8..], e[1]] }
      txt3.map! { |e| [e[0][9..], e[1]] }

      { ck1: ck1, txt1: txt1, ck2: ck2, rfc2: rfc2, ck3: ck3, txt3: txt3 }
    end

    def data_openssl # rubocop:disable Metrics/CyclomaticComplexity
      ck1, txt1, ck2, rfc2, ck3, txt3 = clean_raw_data_openssl.values
      data = ck1.map { |e| [e[1], txt1.select { |x| x[0] == e[0] }[0][1]] }
      data += ck2.map { |e| [e[1], rfc2.select { |x| x[0] == e[0] }[0][1]] }
      data += ck3.map do |e|
        candidate = txt3.select { |x| x[0] == e[0] }
        [e[1], candidate.empty? ? nil : candidate[0][1]]
      end
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
