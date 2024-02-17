# frozen_string_literal: true

# Service for encrypting and decrypting Affine Cipher
class AffineService
  # param plain_text [String]
  # param m [Integer]
  # param b [Integer]
  # return [String]
  def encrypt(plain_text, m, b)
    raise ArgumentError, 'm and 26 are not coprime' if m.gcd(26) != 1

    plain_text = preprocess_text(plain_text)

    cipher_text = ''
    plain_text.each_char do |char|
      cipher_text += encrypt_char(char, m, b)
    end

    cipher_text
  end

  # param cipher_text [String]
  # param m [Integer]
  # param b [Integer]
  # return [String]
  def decrypt(cipher_text, m, b)
    raise ArgumentError, 'm and 26 are not coprime' if m.gcd(26) != 1

    cipher_text = preprocess_text(cipher_text)

    deciphered_text = ''
    cipher_text.each_char do |char|
      deciphered_text += decrypt_char(char, m, b)
    end

    deciphered_text
  end

  private

  # @param char [String]
  # @param m [Integer]
  # @param b [Integer]
  # @return [String]
  def encrypt_char(char, m, b)
    ((m * (char.ord - 'A'.ord) + b) % 26 + 'A'.ord).chr
  end

  # @param char [String]
  # @param m [Integer]
  # @param b [Integer]
  # @return [String]
  def decrypt_char(char, m, b)
    ((mod_inverse(m, 26) * (char.ord - 'A'.ord - b)) % 26 + 'A'.ord).chr
  end

  # @param plain_text [String]
  # @return [String]
  def preprocess_text(plain_text)
    plain_text.upcase.gsub(/[^A-Z]/, '')
  end

  # @param num [Integer]
  # @param mod [Integer]
  # @return [Integer]
  def mod_inverse(num, mod)
    (1..mod).each do |i|
      return i if (num * i) % mod == 1
    end
  end
end

sv = AffineService.new
plain_text = 'if i can stop one heart from breaking'
cipher_text = sv.encrypt(plain_text, 5, 2)
puts(cipher_text)
puts(sv.decrypt(cipher_text, 5, 2))
