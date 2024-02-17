# frozen_string_literal: true

require 'test_helper'

class HillCipherTest < ActiveSupport::TestCase
  test 'should raise error when key is not invertible' do
    service = HillCipherService.new
    plain_text = 'ificanstoponeheartfrombreaking'
    key = Matrix[[0, 1], [0, 0]]

    assert_raise ArgumentError do
      service.encrypt(plain_text, key)
    end

    assert_raise ArgumentError do
      service.decrypt(plain_text, key)
    end
  end

  test 'should encrypt and decrypt' do
    service = HillCipherService.new
    plain_text = 'paymoremoney'
    key = Matrix[[17, 17, 5], [21, 18, 21], [2, 2, 19]]
    cipher_text = service.encrypt(plain_text, key)
    assert_equal 'LNSHDLEWMTRW', cipher_text
    assert_equal 'PAYMOREMONEY', service.decrypt(cipher_text, key)
  end

  test 'should ignore non-alphabet characters' do
    service = HillCipherService.new
    plain_text = 'Pay More Money'
    key = Matrix[[17, 17, 5], [21, 18, 21], [2, 2, 19]]
    cipher_text = service.encrypt(plain_text, key)
    assert_equal 'LNSHDLEWMTRW', cipher_text
    assert_equal 'PAYMOREMONEY', service.decrypt(cipher_text, key)
  end
end
