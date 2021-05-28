# frozen_string_literal: false

require 'minitest/autorun'
require 'minitest/skip_dsl'
require 'tls_map'
require 'tls_map/cli'

class TLSmapCLITest < Minitest::Test
  def test_CLI
    assert(TLSmap::CLI.new)
  end
end
