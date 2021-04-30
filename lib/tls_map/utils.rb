# frozen_string_literal: true

# Ruby internal
require 'net/http'
require 'tempfile'

# TLS map module
module TLSmap
  # TLS mapping
  class App
    def tmpfile(name, url)
      tmp = Tempfile.new(name)
      tmp.write(Net::HTTP.get(URI(url)))
      tmp
    end

    protected :tmpfile
  end
end
