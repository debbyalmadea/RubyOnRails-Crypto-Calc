# frozen_string_literal: true

require_relative '../../lib/enigma/configuration'

# Service for encrypting and decrypting Enigma Cipher
class EnigmaCipherService
  ROTOR_CONFIGURATIONS = {
    1 => 'EKMFLGDQVZNTOWYHXUSPAIBRCJ',
    2 => 'AJDKSIRUXBLHWTMCQGZNPYFVOE',
    3 => 'BDFHJLCPRTXVZNYEIWGAKMUSQO',
    4 => 'ESOVPZJAYQUIRHXLNFTGKDCMWB',
    5 => 'VZBRGITYUPSDNHLXAWMJQOFECK',
    6 => 'JPGVOUMFYQBENHZRDKASXLICTW',
    7 => 'NZJHGRCXMYSWBOUFAIVLPEKQDT',
    8 => 'FKQHTLXOCBJSPDZRAMEWNIUYGV'
  }.freeze

  REFLECTOR_CONFIGURATIONS = {
    1 => 'YRUHQSLDPXNGOKMIEBFZCWVJAT',
    2 => 'FVPJIAOYEDRZXWGCTKUQSBNMHL'
  }.freeze

  # @param plain_text [String]
  # @param configuration [EnigmaConfiguration]
  # @return [String]
  def encrypt(plain_text, configuration, debug = false)
    plugboard_hash = {}
    configuration.plugboard.split(' ').each do |pair|
      plugboard_hash[pair[0]] = pair[1]
      plugboard_hash[pair[1]] = pair[0]
    end

    plain_text = preprocess_text(plain_text)
    cipher_text = ''

    rotor_positions = configuration.rotor_positions.dup
    plain_text.each_char do |char|
      rotor_positions[2] = rotor_positions[2] + 1

      if rotor_positions[2] == 26
        rotor_positions[1] = rotor_positions[1] + 1
        rotor_positions[2] = 0
      end

      if rotor_positions[1] == 26
        rotor_positions[0] = (rotor_positions[0] + 1) % 26
        rotor_positions[1] = 0
      end

      char = process_plugboard(char, plugboard_hash)
      puts char if debug
      char = process_rotor(char, rotor_positions[2], ROTOR_CONFIGURATIONS[configuration.rotors[2]])
      puts char if debug
      char = process_rotor(char, rotor_positions[1], ROTOR_CONFIGURATIONS[configuration.rotors[1]])
      puts char if debug
      char = process_rotor(char, rotor_positions[0], ROTOR_CONFIGURATIONS[configuration.rotors[0]])
      puts char if debug
      char = process_reflector(char, configuration.reflector)
      puts char if debug
      char = process_rotor_inverted(char, rotor_positions[0], ROTOR_CONFIGURATIONS[configuration.rotors[0]])
      puts char if debug
      char = process_rotor_inverted(char, rotor_positions[1], ROTOR_CONFIGURATIONS[configuration.rotors[1]])
      puts char if debug
      char = process_rotor_inverted(char, rotor_positions[2], ROTOR_CONFIGURATIONS[configuration.rotors[2]])
      puts char if debug
      char = process_plugboard(char, plugboard_hash)
      puts char if debug

      cipher_text += char
    end

    cipher_text
  end

  # @param cipher_text [String]
  # @param configuration [EnigmaConfiguration]
  # @return [String]
  def decrypt(cipher_text, configuration)
    encrypt(cipher_text, configuration)
  end

  private

  # @param letter [String]
  # @param plugboard_hash [Hash]
  # @return [String]
  def process_plugboard(letter, plugboard_hash)
    plugboard_hash[letter] || letter
  end

  # @param letter [String]
  # @param rotor_position [Integer]
  # @param rotor_configuration [String]
  # @return [String]
  def process_rotor(letter, rotor_position, rotor_configuration)
    result = rotor_configuration[(letter.ord - 'A'.ord + rotor_position) % 26]
    result = (result.ord - 'A'.ord - rotor_position) % 26
    (result + 'A'.ord).chr
  end

  # @param letter [String]
  # @param rotor_position [Integer]
  # @param rotor_configuration [String]
  # @return [String]
  def process_rotor_inverted(letter, rotor_position, rotor_configuration)
    result = (letter.ord - 'A'.ord + rotor_position) % 26

    rotor_configuration.each_char.with_index do |char, index|
      if (char.ord - 'A'.ord) == result
        result = (index - rotor_position) % 26
        break
      end
    end

    (result + 'A'.ord).chr
  end

  # @param letter [String]
  # @param reflector [Integer]
  # @return [String]
  def process_reflector(letter, reflector)
    REFLECTOR_CONFIGURATIONS[reflector][(letter.ord - 'A'.ord)]
  end

  # @param plain_text [String]
  # @return [String]
  def preprocess_text(plain_text)
    plain_text.upcase.gsub(/[^A-Z]/, '')
  end
end

# config = EnigmaConfiguration.new
# config.reflector = 2
# config.rotors = [4, 2, 3]
# config.rotor_positions = %w[A A A]

# service = EnigmaCipherService.new
# plain_text = 'FFFFFF'
# cipher_text = service.encrypt(plain_text, config)
# puts cipher_text
# puts service.decrypt(cipher_text, config)
