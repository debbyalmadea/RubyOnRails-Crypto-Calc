class ExtendedVigenereCipherController < CipherController
  protected 

  def _calculate(input, key, mode)
    result = ""
    if mode == "encrypt"
      result = ExtendedVigenereCipherService.new.encrypt(input, key)
    else
      result = ExtendedVigenereCipherService.new.decrypt(input, key)
    end

    return result
  end
end