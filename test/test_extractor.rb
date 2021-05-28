# frozen_string_literal: false

require 'minitest/autorun'
require 'minitest/skip_dsl'
require 'tls_map'

class TLSmapExtractorTest < Minitest::Test
  def setup
    @ex = TLSmap::App::Extractor.new
    @ex.parse('ssllabs-scan', 'test/file_sample/ssllabs-scan_newwebsite.json')
  end

  def test_App_Extractor_attributes
    assert_instance_of(Hash, @ex.ciphers)
    assert_instance_of(Array, @ex.ciphers['SSL2.0'])
    assert_empty(@ex.ciphers['SSL3.0'])
    assert_equal('TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384', @ex.ciphers['TLS1.2'][0])
    assert_equal(@ex.ciphers['TLS1.3'], @ex.tls13)
  end

  skip def test_App_Extractor_ssllabs_scan
    # skip, done in setup
  end

  def test_App_Extractor_sslyze
    ex = TLSmap::App::Extractor.new
    assert(ex.parse('sslyze', 'test/file_sample/sslyze.json'))
    assert_includes(ex.ciphers['TLS1.0'], 'TLS_RSA_WITH_CAMELLIA_256_CBC_SHA')
  end

  def test_App_Extractor_sslscan2
    ex = TLSmap::App::Extractor.new
    assert(ex.parse('sslscan2', 'test/file_sample/sslscan2.xml'))
    assert_includes(ex.ciphers['TLS1.3'], 'TLS_CHACHA20_POLY1305_SHA256')
  end

  def test_App_Extractor_testssl
    ex = TLSmap::App::Extractor.new
    assert(ex.parse('testssl', 'test/file_sample/testssl.json'))
    assert_includes(ex.ciphers['TLS1.2'], 'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384')
  end
end
