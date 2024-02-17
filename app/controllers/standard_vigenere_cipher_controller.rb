class StandardVigenereCipherController < CipherController
    protected 
  
    def _calculate(input, key, mode)
      sv = StandardVigenereService.new
  
      result = ""
      if mode == "encrypt"
        result = sv.encrypt(input, key)
      else
        result = sv.decrypt(input, key)
      end
  
      return result
    end
end