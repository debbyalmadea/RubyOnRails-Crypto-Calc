require 'matrix'

class HillCipherController < CipherController
    protected

    def _calculate(params)
      sv = HillCipherService.new

      key = params[:key].split("\n")
      matrix_size = key[0].to_i
      key = key[1..].map { |row| row.split(' ').map(&:to_i) }
      raise 'Invalid key (1)' if key.length != matrix_size

      key.each do |row|
        raise 'Invalid key (2)' if row.length != matrix_size
      end

      key = Matrix[*key]

      result = ''
      if params[:mode] == 'encrypt'
        result = sv.encrypt(params[:input], key)
      else
        result = sv.decrypt(params[:input], key)
      end

      return result
    end
end
