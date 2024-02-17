class PlayfairCipherController < CipherController
  protected 

  def _calculate(params)
    sv = PlayfairCipherService.new
    matrix = sv.generate_matrix(params[:key])

    result = ""
    if params[:mode] == "encrypt"
      result = sv.encrypt(params[:input], matrix)
    else
      result = sv.decrypt(params[:input], matrix)
    end

    return result, {gen_matrix: matrix}
  end
end