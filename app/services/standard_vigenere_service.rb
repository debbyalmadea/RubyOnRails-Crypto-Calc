# frozen_string_literal: true

# Service for encrypting and decrypting Standard Vigenere Cipher
class StandardVigenereService
  # @param plain_text [String]
  # @param key [String]
  # @return [String]
  def encrypt(plain_text, key)
    plain_text = preprocess_text(plain_text)
    key = preprocess_text(key)

    cipher_text = ''
    plain_text.each_char.with_index do |char, index|
      cipher_text += encrypt_char(char, key[index % key.length])
    end

    cipher_text
  end

  # @param cipher_text [String]
  # @param key [String]
  # @return [String]
  def decrypt(cipher_text, key)
    cipher_text = preprocess_text(cipher_text)
    key = preprocess_text(key)

    deciphered_text = ''
    cipher_text.each_char.with_index do |char, index|
      deciphered_text += decrypt_char(char, key[index % key.length])
    end

    deciphered_text
  end

  private

  # @param char [String]
  # @param key [String]
  # @return [String]
  def encrypt_char(char, key)
    ((char.ord + key.ord - 2 * 'A'.ord) % 26 + 'A'.ord).chr
  end

  # @param char [String]
  # @param key [String]
  # @return [String]
  def decrypt_char(char, key)
    ((char.ord - key.ord + 26) % 26 + 'A'.ord).chr
  end

  # @param plain_text [String]
  # @return [String]
  def preprocess_text(plain_text)
    plain_text.upcase.gsub(/[^A-Z]/, '')
  end
end
