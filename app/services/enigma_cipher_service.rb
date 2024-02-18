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

  ROTOR_NOTCHES = {
    1 => %w[Q],
    2 => %w[E],
    3 => %w[V],
    4 => %w[J],
    5 => %w[Z],
    6 => %w[Z M],
    7 => %w[Z M],
    8 => %w[Z M]
  }.freeze

  REFLECTOR_CONFIGURATIONS = {
    1 => 'YRUHQSLDPXNGOKMIEBFZCWVJAT',
    2 => 'FVPJIAOYEDRZXWGCTKUQSBNMHL'
  }.freeze

  # @param plain_text [String]
  # @param configuration [EnigmaConfiguration]
  # @return [String]
  def encrypt(plain_text, configuration)
    plugboard_hash = {}
    configuration.plugboard.split(' ').each do |pair|
      plugboard_hash[pair[0]] = pair[1]
      plugboard_hash[pair[1]] = pair[0]
    end

    plain_text = preprocess_text(plain_text)
    cipher_text = ''

    rotor_positions = configuration.rotor_positions.dup
    plain_text.each_char do |char|
      rotor_positions[2] = (rotor_positions[2] + 1) % 26
      if ROTOR_NOTCHES[configuration.rotors[2]].include?(((rotor_positions[2] - 1) % 26 + 'A'.ord).chr)
        rotor_positions[1] = (rotor_positions[1] + 1) % 26
        if ROTOR_NOTCHES[configuration.rotors[1]].include?(((rotor_positions[1] - 1) % 26 + 'A'.ord).chr)
          rotor_positions[0] = (rotor_positions[0] + 1) % 26
        end
      end

      char = process_plugboard(char, plugboard_hash)
      char = process_rotor(char, configuration.rotors[2], rotor_positions[2], configuration.ring_settings[2])
      char = process_rotor(char, configuration.rotors[1], rotor_positions[1], configuration.ring_settings[1])
      char = process_rotor(char, configuration.rotors[0], rotor_positions[0], configuration.ring_settings[0])
      char = process_reflector(char, configuration.reflector)
      char = process_rotor_inverted(char, configuration.rotors[0], rotor_positions[0], configuration.ring_settings[0])
      char = process_rotor_inverted(char, configuration.rotors[1], rotor_positions[1], configuration.ring_settings[1])
      char = process_rotor_inverted(char, configuration.rotors[2], rotor_positions[2], configuration.ring_settings[2])
      char = process_plugboard(char, plugboard_hash)

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
  # @param rotor_type [Integer]
  # @return [String]
  def process_rotor(letter, rotor_type, rotor_position, ring_setting)
    temp = (rotor_position - ring_setting) % 26

    result = (letter.ord - 'A'.ord + temp) % 26
    result = ROTOR_CONFIGURATIONS[rotor_type][result]
    result = (result.ord - 'A'.ord - temp) % 26
    (result + 'A'.ord).chr
  end

  # @param letter [String]
  # @param rotor_position [Integer]
  # @param rotor_type [Integer]
  # @return [String]
  def process_rotor_inverted(letter, rotor_type, rotor_position, ring_setting)
    temp = (rotor_position - ring_setting) % 26
    result = (letter.ord - 'A'.ord + temp) % 26

    ROTOR_CONFIGURATIONS[rotor_type].each_char.with_index do |char, index|
      if (char.ord - 'A'.ord) == result
        result = (index - temp) % 26
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
