# frozen_string_literal: true

# Ruby internal
require 'net/http'
require 'tempfile'
require 'json'

# TLS map module
module TLSmap
  # Generic utilities
  module Utils
    def tmpfile(name, url)
      tmp = Tempfile.new(name)
      tmp.write(Net::HTTP.get(URI(url)))
      tmp.close
      tmp
    end

    # bring JSON.load_file before ruby 3.0.0
    # https://ruby-doc.org/stdlib-3.0.0/libdoc/json/rdoc/JSON.html#method-i-load_file
    def self.json_load_file(filespec, opts = {})
      if RUBY_VERSION < '3.0.0'
        JSON.parse(File.read(filespec), opts)
      else
        JSON.load_file(filespec, opts)
      end
    end
  end

  # TLS mapping
  class App
    include Utils
    protected :tmpfile
  end
end
