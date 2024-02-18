# frozen_string_literal: true

require 'test_helper'

class EnigmaCipherTest < ActiveSupport::TestCase
  test 'should encrypt and decrypt' do
    service = EnigmaCipherService.new
    configuration = EnigmaConfiguration.new

    plain_text = 'FFFFFF'
    cipher_text = service.encrypt(plain_text, configuration)
    assert_equal 'EKUTGQ', cipher_text
    assert_equal 'FFFFFF', service.decrypt(cipher_text, configuration)

    configuration.reflector = 2
    cipher_text = service.encrypt(plain_text, configuration)
    assert_equal 'SIJSML', cipher_text
    assert_equal 'FFFFFF', service.decrypt(cipher_text, configuration)

    configuration.rotors = [1, 4, 5]
    cipher_text = service.encrypt(plain_text, configuration)
    assert_equal 'SMNUDJ', cipher_text
    assert_equal 'FFFFFF', service.decrypt(cipher_text, configuration)

    configuration.plugboard = 'FN'
    cipher_text = service.encrypt(plain_text, configuration)
    assert_equal 'QQNOAG', cipher_text
    assert_equal 'FFFFFF', service.decrypt(cipher_text, configuration)
  end

  test 'should ignore non-alphabet characters' do
    service = EnigmaCipherService.new
    configuration = EnigmaConfiguration.new

    plain_text = 'FfF F$FF'
    cipher_text = service.encrypt(plain_text, configuration)
    assert_equal 'EKUTGQ', cipher_text
    assert_equal 'FFFFFF', service.decrypt(cipher_text, configuration)
  end
end
