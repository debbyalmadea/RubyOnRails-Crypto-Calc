require 'matrix'

class HillCipherController < CipherController
    protected

    def _calculate(params)
      sv = HillCipherService.new

      key = params[:key].split("\n")
      matrix_size = key[0].to_i
      key = key[1..].map { |row| row.split(' ').map(&:to_i) }
      raise 'Matrix size does not match the key' if matrix_size != key.length

      key.each do |row|
        raise 'Matrix size does not match the key' if matrix_size != row.length
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
