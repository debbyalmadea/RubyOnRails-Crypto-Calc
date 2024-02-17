# frozen_string_literal: true

require 'matrix'

# Service for encrypting and decrypting Hill Cipher
class HillCipherService
  # @param plain_text [String]
  # @param key [Matrix]
  # @return [String]
  def encrypt(plain_text, key)
    raise ArgumentError, 'Invalid key, matrix must be invertible' unless key.regular?

    plain_text = preprocess_text(plain_text, key)

    cipher_text = ''
    (0..plain_text.length / key.row_size - 1).each do |i|
      arr = []

      (0..key.row_size - 1).each do |j|
        arr << plain_text[i * key.row_size + j].ord - 'A'.ord
      end

      mat = Matrix.columns([arr])
      result = (key * mat).map { |x| x % 26 }
      cipher_text += result.to_a.flatten.map { |x| (x + 'A'.ord).chr }.join
    end

    cipher_text
  end

  # @param cipher_text [String]
  # @param key [Matrix]
  # @return [String]
  def decrypt(cipher_text, key)
    raise ArgumentError, 'Invalid key, matrix must be invertible' unless key.regular?

    plain_text = ''
    (0..cipher_text.length / key.row_size - 1).each do |i|
      arr = []

      (0..key.row_size - 1).each do |j|
        arr << cipher_text[i * key.row_size + j].ord - 'A'.ord
      end

      mat = Matrix.columns([arr])
      inversed_key = key.inverse * key.determinant * mod_inverse(key.determinant, 26)
      result = (inversed_key * mat).map { |x| x % 26 }
      plain_text += result.map(&:to_i).to_a.flatten.map { |x| (x + 'A'.ord).chr }.join
    end

    plain_text
  end

  private

  # @param plain_text [String]
  # @param key [Matrix]
  # @return [String]
  def preprocess_text(plain_text, key)
    plain_text = plain_text.upcase.gsub(/[^A-Z]/, '')
    plain_text += 'X' while plain_text.length % key.row_size != 0
    plain_text
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
