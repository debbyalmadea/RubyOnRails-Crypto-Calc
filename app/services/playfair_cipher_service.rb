# frozen_string_literal: true

# Service for encrypting and decrypting Extended Vigenere Cipher
class PlayfairCipherService
    # @param plain_text [String]
    # @param matrix [Array<Array<String>>]
    # @return [String]
    def encrypt(plain_text, matrix)
      bigram_array = preprocess_text(plain_text)
      cipher_text = ''
      bigram_array.each do |bigram|
        cipher_text += encrypt_bigram(bigram, matrix)
      end

      cipher_text
    end
  
    # @param cipher_text [String]
    # @param matrix [Array<Array<String>>]
    # @return [String]
    def decrypt(cipher_text, matrix)
      bigram_array = preprocess_text(cipher_text)
      deciphered_text = ''
      bigram_array.each do |bigram|
        deciphered_text += decrypt_bigram(bigram, matrix)
      end

      deciphered_text
    end

    def generate_matrix(key)
      key = key.upcase.gsub(/[^A-Z]/, '')
      matrix = (key + ('A'..'Z').to_a.join('')).chars.uniq
      matrix.delete('J')
      matrix.each_slice(5).to_a
    end
  
    private
  
    # @param bigram [String]
    # @param key [String]
    # @return [String]
    def encrypt_bigram(bigram, matrix)
        x1, y1 = find_char_pos(bigram[0], matrix)
        x2, y2 = find_char_pos(bigram[1], matrix)

        if x1 == x2 # same row
            return matrix[x1][(y1 + 1) % 5] + matrix[x2][(y2 + 1) % 5]
        elsif y1 == y2 # same column
            return matrix[(x1 + 1) % 5][y1] + matrix[(x2 + 1) % 5][y2]
        else
            return matrix[x1][y2] + matrix[x2][y1]
        end
    end
  
    # @param char [String]
    # @param key [String]
    # @return [String]
    def decrypt_bigram(bigram, matrix)
      x1, y1 = find_char_pos(bigram[0], matrix)
      x2, y2 = find_char_pos(bigram[1], matrix)
      if x1 == x2 # same row
        return matrix[x1][(y1 - 1) % 5] + matrix[x2][(y2 - 1) % 5]
      elsif y1 == y2 # same column
        return matrix[(x1 - 1) % 5][y1] + matrix[(x2 - 1) % 5][y2]
      else
        return matrix[x1][y2] + matrix[x2][y1]
      end
    end

    def find_char_pos(char, matrix)
        matrix.each_with_index do |row, index|
            if row.include?(char)
                return index, row.index(char)
            end
        end
    end

    # @param plain_text [String]
    # @return [Array<String>]
    def preprocess_text(plain_text)
      # change j to i
      plain_text = plain_text.upcase.gsub(/[^A-Z]/, '')
      plain_text.gsub('J', 'I')

      # insert X in between same bigram
      plain_text = plain_text.gsub(/(.)(?=\1)/, '\1X')

      if plain_text.length.odd?
        plain_text += 'X'
      end

      # convert to bigram_array
      bigram_array = plain_text.scan(/../)
      
      bigram_array
    end
  end
  