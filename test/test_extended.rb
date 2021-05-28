# frozen_string_literal: false

require 'minitest/autorun'
require 'minitest/skip_dsl'
require 'tls_map'

class TLSmapExtendedTest < Minitest::Test
  def setup
    @ext = TLSmap::App::Extended.new
  end

  def test_App_Extended_extend
    cipher = 'TLS_RSA_WITH_RC4_128_SHA'
    data = @ext.extend(cipher)
    assert_instance_of(Hash, data)
    assert_instance_of(String, data['protocol_version'])
    assert_instance_of(Array, data['tls_version'])
    assert_instance_of(Hash, data['vulns'][0])
    assert_equal('TLS', data['protocol_version'])
    assert_equal('RSA', data['kex_algorithm'])
    assert_equal('RSA', data['auth_algorithm'])
    assert_equal('RC4 128', data['enc_algorithm'])
    assert_equal('SHA', data['hash_algorithm'])
    assert_equal('insecure', data['security'])
    assert_equal('https://ciphersuite.info/cs/TLS_RSA_WITH_RC4_128_SHA/', data['url'])
  end

  def test_App_Extended_translate_acronym
    assert_equal('Rivest Shamir Adleman algorithm', @ext.translate_acronym('RSA'))
    assert_equal('Digital Signature Standard', @ext.translate_acronym('DSS'))
    assert_nil(@ext.translate_acronym('PPP'))
  end

  def test_App_Extended_find_vuln
    data = @ext.find_vuln('MD5')
    assert_instance_of(Array, data)
    assert_instance_of(Hash, data[0])
    assert_instance_of(Integer, data[0][:severity])
    assert_instance_of(String, data[0][:description])
  end
end
