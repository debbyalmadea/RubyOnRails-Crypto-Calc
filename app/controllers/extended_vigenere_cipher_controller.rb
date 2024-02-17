require "base64"

class ExtendedVigenereCipherController < CipherController
  protected 

  def _calculate(input, key, mode, media_type)
    result = ""
    if mode == "encrypt"
      result = ExtendedVigenereCipherService.new.encrypt(input, key)
    else
      result = ExtendedVigenereCipherService.new.decrypt(input, key)
    end

    return result, media_type
  end
end