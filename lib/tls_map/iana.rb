# frozen_string_literal: true

# Ruby internal
require 'csv'

# TLS map module
module TLSmap
  # TLS mapping
  class App
    IANA_URL = 'https://www.iana.org/assignments/tls-parameters/tls-parameters-4.csv'

    # remove Reserved, Unassigned codepoints (those with a range: X-X or *)
    # also works with gnutls
    def codepoint_iana(raw_cp)
      c1, c2 = raw_cp.split(',')
      c2.strip!
      return nil unless c2.size == 4

      "#{c1[2..3]}#{c2[2..3]}"
    end

    # remove remaining Reserved, Unassigned codepoints
    def desc_iana(desc)
      return nil if /Reserved|Unassigned/.match?(desc)

      desc
    end

    def parse_iana
      CSV.foreach(@iana_file.path, **{ headers: true, header_converters: :symbol }) do |alg|
        codepoint = codepoint_iana(alg[:value])
        description = desc_iana(alg[:description])
        @tls_map << { codepoint: codepoint, iana: description } unless codepoint.nil? || description.nil?
      end
    end

    private :codepoint_iana, :desc_iana, :parse_iana
  end
end
