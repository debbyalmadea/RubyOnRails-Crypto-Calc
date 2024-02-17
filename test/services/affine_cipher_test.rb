# frozen_string_literal: true

require 'test_helper'

class AffineCipherTest < ActiveSupport::TestCase
  test 'should raise error when m and 26 are not coprime' do
    service = AffineCipherService.new
    plain_text = 'ificanstoponeheartfrombreaking'
    assert_raise ArgumentError do
      service.encrypt(plain_text, 2, 2)
    end
  end

  test 'should encrypt and decrypt' do
    service = AffineCipherService.new
    plain_text = 'ificanstoponeheartfrombreaking'
    cipher_text = service.encrypt(plain_text, 5, 2)
    assert_equal 'QBQMCPOTUZUPWLWCJTBJUKHJWCAQPG', cipher_text
    assert_equal 'IFICANSTOPONEHEARTFROMBREAKING', service.decrypt(cipher_text, 5, 2)
  end

  test 'should ignore non-alphabet characters' do
    service = AffineCipherService.new
    plain_text = 'If I can stop one heart from breaking'
    cipher_text = service.encrypt(plain_text, 5, 2)
    assert_equal 'QBQMCPOTUZUPWLWCJTBJUKHJWCAQPG', cipher_text
    assert_equal 'IFICANSTOPONEHEARTFROMBREAKING', service.decrypt(cipher_text, 5, 2)
  end
end
