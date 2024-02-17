class ExtendedVigenereCipherController < CipherController
  protected 

  def _calculate(params)
    result = ""
    if params[:mode] == "encrypt"
      result = ExtendedVigenereCipherService.new.encrypt(params[:input], params[:key])
    else
      result = ExtendedVigenereCipherService.new.decrypt(params[:input], params[:key])
    end

    return result
  end
end