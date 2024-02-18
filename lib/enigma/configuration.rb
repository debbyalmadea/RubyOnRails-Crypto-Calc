# frozen_string_literal: true

# Class to store Enigma configuration
class EnigmaConfiguration
  # Enigma configuration

  # Reflector:
  # 1: B
  # 2: C

  # Plugboard:
  # String with pairs of letter with whitespace as separator
  # Example: 'AB CD EF'

  # Rotors:
  # 1: I
  # 2: II
  # 3: III
  # 4: IV
  # 5: V
  # 6: VI
  # 7: VII
  # 8: VIII
  # Array with 3 integers, starting from the slowest rotor to the fastest rotor

  # @param reflector [Integer]
  # @param plugboard [String]
  # @param rotors [Array<Integer>]
  # @param rotor_positions [Array<Integer>]
  attr_reader :reflector, :plugboard, :rotors, :rotor_positions

  def initialize
    @reflector = 1
    @plugboard = ''
    @rotors = [1, 2, 3]
    @rotor_positions = [0, 0, 0]
  end

  # @param reflector [Integer]
  # @return [Integer]
  # @raise [ArgumentError]
  def reflector=(reflector)
    raise ArgumentError, 'Not a valid value for reflector' unless [1, 2].include?(reflector)

    @reflector = reflector
  end

  # @param plugboard [String]
  # @return [String]
  # @raise [ArgumentError]
  def plugboard=(plugboard)
    plugboard = plugboard.upcase
    plugboard_regex = /^[A-Z]{2}( [A-Z]{2})*$/
    raise ArgumentError, 'Not a valid value for plugboard' unless plugboard.match?(plugboard_regex) || plugboard.empty?

    @plugboard = plugboard
  end

  # @param rotors [Array<Integer>]
  # @return [Array<Integer>]
  # @raise [ArgumentError]
  def rotors=(rotors)
    raise ArgumentError, 'The number of rotors must be 3' unless rotors.length == 3
    raise ArgumentError, 'Not a valid value for rotors' unless rotors.all? { |rotor| (1..8).include?(rotor) }

    @rotors = rotors
  end

  # @param rotor_positions [Array<String>]
  # @return [Array<Integer>]
  # @raise [ArgumentError]
  def rotor_positions=(rotor_positions)
    raise ArgumentError, 'The number of rotor positions must be 3' unless rotor_positions.length == 3

    is_rotor_position_valid = rotor_positions.all? { |position| position.match?(/^[A-Z]$/) }
    raise ArgumentError, 'Not a valid value for rotor_positions' unless is_rotor_position_valid

    @rotor_positions = rotor_positions.map { |position| position.ord - 'A'.ord }
  end
end
