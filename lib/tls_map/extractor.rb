# frozen_string_literal: true

# Ruby internal
require 'json'
# Project internal
require 'tls_map/cli'
# External
require 'rexml/document'

module TLSmap
  class App
    # External tools output data extractor
    #
    # Output files from [SSLyze][1] (JSON), [sslscan2][2] (XML), [testssl.sh][3] (JSON), [ssllabs-scan][4] (JSON)
    #
    # [1]:https://github.com/nabla-c0d3/sslyze
    # [2]:https://github.com/rbsec/sslscan
    # [3]:https://github.com/drwetter/testssl.sh
    # [4]:https://github.com/ssllabs/ssllabs-scan
    #
    # Example of commands:
    #
    # - `sslyze --json_out=example.org.json example.org`
    # - `sslscan2 --show-cipher-ids --xml=example.org.xml example.org`
    #   - `--show-cipher-ids` is mandatory else ciphers are not saved to the output
    # - `testssl --jsonfile-pretty example.org.json --mapping no-openssl --cipher-per-proto example.org`
    #   - json-pretty is the only supported format, default json or csv, html won't work
    # - `ssllabs-scan --quiet example.org > example.org.json`
    #   - The default output is the only supported format, using `-json-flat` won't work
    class Extractor
      # Get the list of ciphers extracted from the tool output file
      # @return [Array<String>] Cipher array (IANA names)
      attr_reader :ciphers

      # Initialize {TLSmap::App::Extractor} instance
      def initialize
        @ciphers = []
      end

      # Return only the SSL 2.0 ciphers
      # @return [Array<String>] Cipher array (IANA names)
      def ssl20
        @ciphers['SSL2.0']
      end

      # Return only the SSL 3.0 ciphers
      # @return [Array<String>] Cipher array (IANA names)
      def ssl30
        @ciphers['SSL3.0']
      end

      # Return only the TLS 1.0 ciphers
      # @return [Array<String>] Cipher array (IANA names)
      def tls10
        @ciphers['TLS1.0']
      end

      # Return only the TLS 1.1 ciphers
      # @return [Array<String>] Cipher array (IANA names)
      def tls11
        @ciphers['TLS1.1']
      end

      # Return only the TLS 1.2 ciphers
      # @return [Array<String>] Cipher array (IANA names)
      def tls12
        @ciphers['TLS1.2']
      end

      # Return only the TLS 1.3 ciphers
      # @return [Array<String>] Cipher array (IANA names)
      def tls13
        @ciphers['TLS1.3']
      end

      # Extract the ciphers from the tool output file
      # @param tool [String] Possible values: `sslyze`, `sslscan2`, `testssl`, `ssllabs-scan`
      # @param file [String] Path of the tool output file, beware of the format expected. See {TLSmap::App::Extractor}
      # @return [Array<String>] Cipher array (IANA names)
      def parse(tool, file)
        # Convert string to class
        @ciphers = Object.const_get("TLSmap::App::Extractor::#{normalize(tool)}").parse(file)
      end

      # Convert cmdline tool name to Class name
      def normalize(tool)
        tool.split('-').map(&:capitalize).join
      end

      protected :normalize

      # Parsing SSLyze
      class Sslyze
        class << self
          # Extract the ciphers from the sslyze output file
          # @param file [String] Path of the sslyze output file, beware of the format expected.
          #   See {TLSmap::App::Extractor}
          # @return [Array<String>] Cipher array (IANA names)
          def parse(file)
            data = Utils.json_load_file(file)
            extract_cipher(data)
          end

          # Extract the ciphers from the sslyze output file
          # @param json_data [Hash] Ruby hash of the parsed JSON
          # @return [Array<String>] Cipher array (IANA names)
          def extract_cipher(json_data)
            ciphers = json_data['server_scan_results'][0]['scan_commands_results']
            raw = {
              'SSL2.0' => ciphers['ssl_2_0_cipher_suites']['accepted_cipher_suites'],
              'SSL3.0' => ciphers['ssl_3_0_cipher_suites']['accepted_cipher_suites'],
              'TLS1.0' => ciphers['tls_1_0_cipher_suites']['accepted_cipher_suites'],
              'TLS1.1' => ciphers['tls_1_1_cipher_suites']['accepted_cipher_suites'],
              'TLS1.2' => ciphers['tls_1_2_cipher_suites']['accepted_cipher_suites'],
              'TLS1.3' => ciphers['tls_1_3_cipher_suites']['accepted_cipher_suites']
            }
            raw.transform_values { |v| v.empty? ? v : v.map { |x| x['cipher_suite']['name'] } }
          end

          protected :extract_cipher
        end
      end

      # Parsing sslscan2
      class Sslscan2
        class << self
          # Extract the ciphers from the sslscan2 output file
          # @param file [String] Path of the sslscan2 output file, beware of the format expected.
          #   See {TLSmap::App::Extractor}
          # @return [Array<String>] Cipher array (IANA names)
          def parse(file, online = false)
            doc = REXML::Document.new(File.new(file))
            extract_cipher(doc, online)
          end

          # Extract the ciphers from the sslscan2 output file
          # @param xml_doc [REXML::Document] XML document as returned by `REXML::Document`
          # @param online By default use the offline mode with {TLSmap::CLI} for better performance.
          #   Online mode will use {TLSmap::App} and fetch upstream resources to get latest updates but is a lot slower.
          # @return [Array<String>] Cipher array (IANA names)
          def extract_cipher(xml_doc, online = false) # rubocop:disable Metrics/MethodLength
            raw = {
              'SSL2.0' => [], 'SSL3.0' => [],
              'TLS1.0' => [], 'TLS1.1' => [], 'TLS1.2' => [], 'TLS1.3' => []
            }
            tm = online ? TLSmap::App.new : TLSmap::CLI.new
            xml_doc.root.each_element('//cipher') do |node|
              sslv = node.attributes['sslversion'].gsub('v', '')
              cipher = tm.search(:codepoint, node.attributes['id'][2..], :iana)[:iana]
              raw[sslv].push(cipher)
            end
            raw
          end

          protected :extract_cipher
        end
      end

      # Parsing testssl.sh
      class Testssl
        class << self
          # Extract the ciphers from the testssl output file
          # @param file [String] Path of the testssl output file, beware of the format expected.
          #   See {TLSmap::App::Extractor}
          # @return [Array<String>] Cipher array (IANA names)
          def parse(file)
            data = Utils.json_load_file(file)
            extract_cipher(data)
          end

          # Extract the ciphers from the testssl output file
          # @param json_data [Hash] Ruby hash of the parsed JSON
          # @return [Array<String>] Cipher array (IANA names)
          def extract_cipher(json_data)
            cipher = json_data['scanResult'][0]['cipherTests']
            raw = {
              'SSL2.0' => [], 'SSL3.0' => [],
              'TLS1.0' => [], 'TLS1.1' => [], 'TLS1.2' => [], 'TLS1.3' => []
            }
            cipher.each do |node|
              raw[id2prot(node['id'])].push(finding2cipher(node['finding']))
            end
            raw
          end

          # Convert testssl protocol id to protocol name in TLSmap format
          # @param id [String] testssl protocol id
          # @return [String] protocol name in TLSmap format
          def id2prot(id)
            prot = {
              'ssl2' => 'SSL2.0', 'ssl3' => 'SSL3.0', 'tls1' => 'TLS1.0',
              'tls1_1' => 'TLS1.1', 'tls1_2' => 'TLS1.2', 'tls1_3' => 'TLS1.3'
            }
            protv = id.match(/cipher-(\w+)_x\w+/).captures[0]
            prot[protv]
          end

          # Extract the cipher name from testssl finding
          # @param finding [String] testssl finding
          # @return [String] cipher name (IANA names)
          def finding2cipher(finding)
            /\s(\w+_\w+)\s/.match(finding).captures[0]
          end

          protected :extract_cipher, :id2prot, :finding2cipher
        end
      end

      # Parsing ssllabs-scan
      class SsllabsScan
        class << self
          # Extract the ciphers from the ssllabs-scan output file
          # @param file [String] Path of the ssllabs-scan output file, beware of the format expected.
          #   See {TLSmap::App::Extractor}
          # @return [Array<String>] Cipher array (IANA names)
          def parse(file)
            data = Utils.json_load_file(file)
            extract_cipher(data)
          end

          # Extract the ciphers from the ssllabs-scan output file
          # @param json_data [Hash] Ruby hash of the parsed JSON
          # @return [Array<String>] Cipher array (IANA names)
          def extract_cipher(json_data) # rubocop:disable Metrics/MethodLength
            raw = {
              'SSL2.0' => [], 'SSL3.0' => [],
              'TLS1.0' => [], 'TLS1.1' => [], 'TLS1.2' => [], 'TLS1.3' => []
            }
            json_data[0]['endpoints'].each do |endpoint|
              endpoint['details']['suites'].each do |suite|
                suite['list'].each do |cipher|
                  raw[id2prot(suite['protocol'])].push(cipher['name'])
                end
              end
            end
            raw.transform_values(&:uniq)
          end

          # Convert ssllabs-scan protocol id to protocol name in TLSmap format
          # @param id [String] ssllabs-scan protocol id
          # @return [String] protocol name in TLSmap format
          def id2prot(id)
            prot = {
              512 => 'SSL2.0', 768 => 'SSL3.0', 769 => 'TLS1.0',
              770 => 'TLS1.1', 771 => 'TLS1.2', 772 => 'TLS1.3'
            }
            prot[id]
          end

          protected :extract_cipher, :id2prot
        end
      end
    end
  end
end
