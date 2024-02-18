# frozen_string_literal: true

# Service for encrypting and decrypting Standard Vigenere Cipher
class TransposeCipherService
    # @param plain_text [String]
    # @param key [String]
    # @return [String]
    def encrypt(plain_text, key)
      # puts plain_text
      matrix, remainder_array = preprocess_text(plain_text, key.length)

      # puts "matriks #{matrix}"
      # puts "remainder array #{remainder_array}"
      
      matrix = matrix.transpose
      # puts "transpose #{matrix}"

      if remainder_array
        remainder_array.each_with_index do |c, i|
          matrix[i] << c
        end
      end

      # puts "concat remainder #{matrix}"

      order = preprocess_key(key)

      # puts "order #{order}" 

      cipher_text = ''

      # read the matrix row by row based on the order of the key
      order.each do |i|
        cipher_text += matrix[i].join('')
      end

      # puts "cipher text #{cipher_text}"

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

      # puts "order #{order}"

      (cipher_text.length % key.length).times do |i|
        remainder_char_idx = len * order[i] + len
        remainder_array << cipher_text[remainder_char_idx]
        cipher_text = cipher_text[0...remainder_char_idx] + cipher_text[remainder_char_idx + 1..-1]
      end

      # puts "remainder array #{remainder_array}"

      matrix, _ = preprocess_text(cipher_text, len)

      # puts "matriks #{matrix}"

      # reorder the matrix based on the order of the key
      matrix = order.map { |i| matrix[i] }.transpose

      # puts "reorder #{matrix}"

      if remainder_array
        matrix << remainder_array
      end

      # puts "concat remainder #{matrix}"

      deciphered_text = matrix.join('')

      # puts "deciphered text #{deciphered_text}"

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
  