# frozen_string_literal: true

require 'test_helper'

class TransposeCipherTest < ActiveSupport::TestCase
  test 'should encrypt and decrypt' do
    sv = TransposeCipherService.new
    key = 'koentji'
    plaintext_bytes = [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33, 255, 128, 64]
    plaintext = plaintext_bytes.pack("C*") # Convert bytes array to string
    encrypted_text = sv.encrypt(plaintext, key)
    decrypted_text = sv.decrypt(encrypted_text, key)
    assert_equal plaintext, decrypted_text
  end

  test 'should encrypt and decrypt 2' do
    sv = TransposeCipherService.new
    key = 'ZEBRAS'
    plaintext = 'WEAREDISCOVEREDFLEEATONCE'
    encrypted_text = sv.encrypt(plaintext, key)
    decrypted_text = sv.decrypt(encrypted_text, key)
    assert_equal encrypted_text, "EVLNACDTESEAROFODEECWIREE"
    assert_equal decrypted_text, plaintext
  end
end
