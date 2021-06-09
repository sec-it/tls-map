# frozen_string_literal: false

require 'minitest/autorun'
require 'minitest/skip_dsl'
require 'tls_map'

class TLSmapAppTest < Minitest::Test
  def setup
    @tm = TLSmap::App.new
  end

  def test_App_search
    assert_equal({:iana=>"TLS_RSA_WITH_RC4_128_SHA"}, @tm.search(:gnutls, 'RSA_ARCFOUR_128_SHA1', :iana))
    assert_equal({:iana=>"TLS_RSA_WITH_AES_128_CBC_SHA"}, @tm.search(:openssl, 'AES128-SHA', :iana))
    assert_equal({:codepoint=>"0037"}, @tm.search(:iana, 'TLS_DH_RSA_WITH_AES_256_CBC_SHA', :codepoint))
    assert_equal({:codepoint=>"1303", :iana=>"TLS_CHACHA20_POLY1305_SHA256", :openssl=>"TLS_CHACHA20_POLY1305_SHA256", :gnutls=>"CHACHA20_POLY1305_SHA256", :nss=>"TLS_CHACHA20_POLY1305_SHA256"}, @tm.search(:codepoint, '1303'))
    assert_equal({:codepoint=>"1302", :iana=>"TLS_AES_256_GCM_SHA384", :openssl=>"TLS_AES_256_GCM_SHA384", :gnutls=>"AES_256_GCM_SHA384", :nss=>"TLS_AES_256_GCM_SHA384"}, @tm.search(:nss, 'TLS_AES_256_GCM_SHA384'))
  end

  def test_App_bulk_search
    res = @tm.bulk_search(:iana, 'test/file_sample/bulk_IANA.txt', :openssl)
    assert_equal({:openssl=>"DH-RSA-AES256-SHA"}, res[0])
    assert_equal({:openssl=>"RC4-SHA"}, res[1])
    assert_equal({:openssl=>"AES128-SHA"}, res[2])
    assert_equal({}, res[3])
    res = @tm.bulk_search(:iana, 'test/file_sample/bulk_IANA.txt', :codepoint)
    assert_equal({:codepoint=>"1303"}, res[4])
    res = @tm.bulk_search(:iana, 'test/file_sample/bulk_IANA.txt', :iana)
    assert_equal({:iana=>"TLS_AES_256_GCM_SHA384"}, res[5])
  end

  def test_App_export
    formats = [:markdown, :json_pretty, :json_compact, :marshal]
    formats.each do |format|
      tmp = Tempfile.new
      assert_instance_of(Integer, @tm.export(tmp.path, format))
      tmp.close
    end
    assert_raises(RuntimeError, 'Wrong format: wrong') {@tm.export('/dev/shm/tlsmap', :wrong)}
  end
end
