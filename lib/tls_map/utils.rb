# frozen_string_literal: true

# Ruby internal
require 'net/http'
require 'tempfile'

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
  end

  # TLS mapping
  class App
    include Utils
    protected :tmpfile
  end
end
