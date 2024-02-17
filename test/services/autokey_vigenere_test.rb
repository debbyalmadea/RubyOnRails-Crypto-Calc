# frozen_string_literal: true

require 'test_helper'

class AutokeyVigenereTest < ActiveSupport::TestCase
  test 'should encrypt and decrypt' do
    sv = AutokeyVigenereService.new
    key = 'koentji'
    plain_text = 'bingungmauplainteksapa'
    cipher_text = sv.encrypt(plain_text, key)
    assert_equal 'LWRTNWONIHVFNOZTYZDAXN', cipher_text
    assert_equal 'BINGUNGMAUPLAINTEKSAPA', sv.decrypt(cipher_text, key)
  end

  test 'should ignore non-alphabet characters' do
    sv = AutokeyVigenereService.new
    key = 'koent ji'
    plain_text = 'Bingung Mau Plain Teks Apa'
    cipher_text = sv.encrypt(plain_text, key)
    assert_equal 'LWRTNWONIHVFNOZTYZDAXN', cipher_text
    assert_equal 'BINGUNGMAUPLAINTEKSAPA', sv.decrypt(cipher_text, key)
  end
end
