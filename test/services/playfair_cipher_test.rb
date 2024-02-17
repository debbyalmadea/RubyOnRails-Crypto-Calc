# frozen_string_literal: true

require 'test_helper'

class PlayfairCipherTest < ActiveSupport::TestCase
  test 'should encrypt and decrypt' do
    sv = PlayfairCipherService.new
    key = 'jalan ganesha sepuluh'
    plain_text = 'temui ibu nanti malam'
    cipher_text = sv.encrypt(plain_text, key)
    assert_equal 'ZBRSFYKUPGLGRKVSNLQV', cipher_text
    assert_equal 'TEMUIXIBUNANTIMALAMX', sv.decrypt(cipher_text, key)
  end

  test 'should ignore non-alphabet characters' do
    sv = PlayfairCipherService.new
    key = '@jalan@ gan@esha sepuluh'
    plain_text = 'temui@ ibu#nanti malam!'
    cipher_text = sv.encrypt(plain_text, key)
    assert_equal 'ZBRSFYKUPGLGRKVSNLQV', cipher_text
    assert_equal 'TEMUIXIBUNANTIMALAMX', sv.decrypt(cipher_text, key)
  end
end