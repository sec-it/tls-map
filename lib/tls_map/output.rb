# frozen_string_literal: true

# Ruby internal
require 'json'

# TLS map module
module TLSmap
  # TLS mapping
  class App
    def markdown(table)
      output = "Codepoint | IANA | OpenSSL | GnuTLS | NSS\n"
      output += "--- | --- | --- | --- | ---\n"
      table.each do |alg|
        values = alg.values.map { |x| x.nil? ? '-' : x }
        output += "#{values.join(' | ')}\n"
      end
      output
    end

    def output_markdown(filename)
      File.write(filename, markdown(@tls_map))
    end

    def output_json_pretty(filename)
      File.write(filename, JSON.pretty_generate(@tls_map))
    end

    def output_json_compact(filename)
      File.write(filename, JSON.generate(@tls_map))
    end

    def output_marshal(filename)
      File.write(filename, Marshal.dump(@tls_map))
    end

    # Export the mapping to a file, supporting various formats.
    # @param filename [String] The output file name to write to.
    # @param format [Symbol] Supported formats: `:markdown` (a markdown table),
    #   `:json_pretty` (expanded JSON), `:json_compact` (minified JSON),
    #   `:marshal` (Ruby marshalized hash).
    def export(filename, format)
      case format
      when :markdown      then output_markdown(filename)
      when :json_pretty   then output_json_pretty(filename)
      when :json_compact  then output_json_compact(filename)
      when :marshal       then output_marshal(filename)
      else                     raise "Wrong format: #{format}"
      end
    end

    protected :markdown, :output_markdown, :output_json_pretty, :output_json_compact, :output_marshal
  end
end
