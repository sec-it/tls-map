# frozen_string_literal: true

# Ruby internal
require 'net/http'
require 'json'
require 'yaml'
# Project internal

# TLS map module
module TLSmap
  class App
    # Partial wrapper around ciphersuite.info API to get extra info about a cipher
    #
    # Documentation:
    #
    # - https://ciphersuite.info/blog/2019/04/05/how-to-use-our-api/
    # - https://github.com/OAI/OpenAPI-Specification/blob/main/versions/3.0.0.md
    # - https://ciphersuite.info/api/
    # - https://github.com/hcrudolph/ciphersuite.info
    class Extended
      # Root URL of Cipher Suite Info
      ROOT = 'https://ciphersuite.info/'
      # Root URL of Cipher Suite Info API
      API_ROOT = "#{ROOT}api/"
      # URL of the data file containig vulnerabilities information
      VULN_DATA = 'https://raw.githubusercontent.com/hcrudolph/ciphersuite.info/master/directory/fixtures/00_vulnerabilities.yaml'
      # URL of the data file containig technologies information
      TECH_DATA = 'https://raw.githubusercontent.com/hcrudolph/ciphersuite.info/master/directory/fixtures/01_technologies.yaml'
      # Hash mapping API key and display name for CLI
      DICO = {
        'tls_version' => 'TLS Version(s)',
        'protocol_version' => 'Protocol',
        'kex_algorithm' => 'Key Exchange',
        'auth_algorithm' => 'Authentication',
        'enc_algorithm' => 'Encryption',
        'hash_algorithm' => 'Hash',
        'security' => 'Security',
        'url' => 'More info',
        'vulns' => 'Vulnerabilities'
      }.freeze
      # Hash mapping the severity number used by the API and the severity text and color for the CLI
      VULN_SEVERITY = {
        0 => { title: 'Low', color: :yellow },
        1 => { title: 'Medium', color: 'orange' },
        2 => { title: 'High', color: :red }
      }.freeze

      include Utils
      protected :tmpfile

      # Will automatically fetch source files and parse them.
      def initialize
        @tech_file = tmpfile('tech', TECH_DATA)
        @vuln_file = tmpfile('vuln', VULN_DATA)
        @tech = parse_tech
        @vuln = parse_vuln
      end

      # Retrieve advanced about a cipher on Cipher Suite Info API and enhanced it
      # @param iana_name [String] IANA cipher name
      # @return [Hash] Hash containing advanced information. The keys are the same as {DICO}. All valeus are string
      #   except `vulns` which is an array of hashes containing two keys: `:severity` (integer) and `:description`
      #   (string). Each hash in `vulns` correspond to a vulnerability.
      def extend(iana_name) # rubocop:disable Metrics/MethodLength
        obj = Net::HTTP.get(URI("#{API_ROOT}cs/#{iana_name}/"))
        out = JSON.parse(obj)[iana_name]
        out.store('vulns', [])
        %w[openssl_name gnutls_name hex_byte_1 hex_byte_2].each do |key|
          out.delete(key)
        end
        out.each_value do |v|
          out['vulns'].push(find_vuln(v)) if @tech.keys.include?(v)
        end
        out['vulns'].flatten!
        out['vulns'].uniq!
        out.store('url', "#{ROOT}cs/#{iana_name}/") # Add upstream URL
        out
      end

      # Extract data from the YAML file ({TECH_DATA}) to craft a simplified Ruby hash
      def parse_tech
        data = Psych.load_file(@tech_file)
        out = {}
        data.each do |item|
          out.store(item['pk'], { long_name: item['fields']['long_name'],
                                  vulnerabilities: item['fields']['vulnerabilities'] })
        end
        out
      end

      # Extract data from the YAML file ({VULN_DATA}) to craft a simplified Ruby hash
      def parse_vuln
        data = Psych.load_file(@vuln_file)
        out = {}
        data.each do |item|
          out.store(item['pk'], { severity: item['fields']['severity'],
                                  description: item['fields']['description'] })
        end
        out
      end

      # Translate cipher related acronyms
      # @param term [String] Acronym, eg. DSS
      # @return [String] The long name of the acronym, eg. Digital Signature Standard or `nil` if it's not found
      def translate_acronym(term)
        return @tech[term][:long_name] unless @tech[term].nil?

        nil
      end

      # Find vulnerabilities related to a technology
      # @param tech [String] The technology acronym, eg. CBC
      # @return [Array<Hash>] Array of vulnerabilities as described for {extend} return value in the `vulns` key.
      def find_vuln(tech)
        return @tech[tech][:vulnerabilities].map { |vuln| @vuln[vuln] } unless @tech[tech][:vulnerabilities].nil?

        nil
      end

      protected :parse_tech, :parse_vuln
    end
  end
end
