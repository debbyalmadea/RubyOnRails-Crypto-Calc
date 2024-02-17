class PlayfairCipherController < CipherController
  protected 

  def _calculate(input, key, mode)
    sv = PlayfairCipherService.new
    matrix = sv.generate_matrix(key)

    result = ""
    if mode == "encrypt"
      result = sv.encrypt(input, matrix)
    else
      result = sv.decrypt(input, matrix)
    end

    return result, {gen_matrix: matrix}
  end
end