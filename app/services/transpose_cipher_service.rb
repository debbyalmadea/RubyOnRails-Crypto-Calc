# frozen_string_literal: true

# Service for encrypting and decrypting Standard Vigenere Cipher
class TransposeCipherService
    # @param plain_text [String]
    # @param key [String]
    # @return [String]
    def encrypt(plain_text, key)
      # puts plain_text
      matrix, remainder_array = preprocess_text(plain_text, key.length)
      
      matrix = matrix.transpose

      if remainder_array
        remainder_array.each_with_index do |c, i|
          matrix[i] << c
        end

        (key.length - remainder_array.length).times do |i|
          matrix[remainder_array.length + i] << 0.chr
        end
      end

      order = preprocess_key(key)

      cipher_text = ''

      order.each do |i|
        cipher_text += matrix[i].join('')
      end

      cipher_text
    end
  
    # @param cipher_text [String]
    # @param key [String]
    # @return [String]
    def decrypt(cipher_text, key)
      len = cipher_text.length / key.length

      remainder_array = []
      
      order = preprocess_key(key)
      order = key.length.times.map { |i| order.index(i) }

      matrix, _ = preprocess_text(cipher_text, len)

      matrix = order.map { |i| matrix[i] }.transpose

      if remainder_array
        matrix << remainder_array
      end

      deciphered_text = matrix.join('')

      deciphered_text
    end
  
    private
  
    # @param plain_text [String]
    # @param k [Integer]
    # @return [Array<Array<String>>] matrix of the plain text already rotated
    def preprocess_text(plain_text, k)      
      matrix = plain_text.chars.each_slice(k).to_a
      
      remainder_array = matrix.pop if plain_text.length % k != 0

      return matrix, remainder_array
    end

    # @param key [String]
    # @return [Array<Integer>] order of the key
    def preprocess_key(key)
      # get index order of the key from smallest to largest
      key.chars.each_with_index.sort_by { |c, i| c.ord }.map { |c, i| i }
    end
  end
  