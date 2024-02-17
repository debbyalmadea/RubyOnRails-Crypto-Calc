# frozen_string_literal: true

# Service for encrypting and decrypting Extended Vigenere Cipher
class ExtendedVigenereCipherService
    # @param plain_text [String]
    # @param key [String]
    # @return [String]
    def encrypt(plain_text, key)
      cipher_text = ''
      plain_text.bytes.each_with_index do |byte, index|
        cipher_text += encrypt_char(byte, key[index % key.length])
      end
  
      cipher_text
    end
  
    # @param cipher_text [String]
    # @param key [String]
    # @return [String]
    def decrypt(cipher_text, key)
      deciphered_text = ''
      cipher_text.bytes.each_with_index do |byte, index|
        deciphered_text += decrypt_char(byte, key[index % key.length])
      end
  
      deciphered_text
    end
  
    private
  
    # @param char [String]
    # @param key [String]
    # @return [String]
    def encrypt_char(char, key)
      ((char.ord + key.ord) % 256).chr
    end
  
    # @param char [String]
    # @param key [String]
    # @return [String]
    def decrypt_char(char, key)
      ((char.ord - key.ord) % 256).chr
    end
  end
  