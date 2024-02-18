# frozen_string_literal: true

# Service for encrypting and decrypting Standard Vigenere Cipher
class SuperEncryptionService
    # @param plain_text [String]
    # @param key [String]
    # @return [String]
    def encrypt(plain_text, key)
      extendedSV = ExtendedVigenereCipherService.new
      transposeSV = TransposeCipherService.new

      cipher_text = extendedSV.encrypt(plain_text, key)
      transposeSV.encrypt(cipher_text, key)
    end
  
    # @param cipher_text [String]
    # @param key [String]
    # @return [String]
    def decrypt(cipher_text, key)
      extendedSV = ExtendedVigenereCipherService.new
      transposeSV = TransposeCipherService.new
    
      deciphered_text = transposeSV.decrypt(cipher_text, key)
      extendedSV.decrypt(deciphered_text, key)
    end  
end
  