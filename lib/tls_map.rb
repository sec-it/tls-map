# frozen_string_literal: true

# Ruby internal
require 'pathname'
# Project internal
require 'tls_map/version'
require 'tls_map/utils'
require 'tls_map/iana'
require 'tls_map/openssl'
require 'tls_map/gnutls'
require 'tls_map/nss'
require 'tls_map/output'
require 'tls_map/ciphersuiteinfo'

# TLS map module
module TLSmap
  # TLS mapping
  class App
    # Will automatically fetch source files and parse them.
    def initialize
      @iana_file = tmpfile('iana', IANA_URL)
      @openssl_file = tmpfile('openssl', OPENSSL_URL)
      @openssl_file2 = tmpfile('openssl', OPENSSL_URL2)
      @gnutls_file = tmpfile('gnutls', GNUTLS_URL)
      @nss_file = tmpfile('nss', NSS_URL)

      @tls_map = []
      parse
    end

    def parse
      parse_iana # must be first
      parse_openssl
      parse_gnutls
      parse_nss
    end

    # Search for corresponding cipher algorithms in other libraries
    # @param critera [Symbol] The type of +term+.
    #   Accepted values: +:codepoint+, +:iana+, +:openssl+, +:gnutls+, +:nss+.
    # @param term [String] The cipher algorithm name.
    # @param output [Symbol] The corresponding type to be included in the return value.
    #   Accepted values: +:all+ (default), +:codepoint+, +:iana+, +:openssl+,
    #   +:gnutls+, +:nss+.
    # @return [Hash] The corresponding type matching +term+.
    def search(critera, term, output = :all)
      @tls_map.each do |alg|
        term = term.upcase if critera == :codepoint
        next unless alg[critera] == term
        return alg if output == :all

        return { output => alg[output] }
      end
      {}
    end

    protected :parse
  end
end
