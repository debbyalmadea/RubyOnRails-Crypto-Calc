class SuperEncryptionController < CipherController
    protected 
  
    def _calculate(params)
      sv = SuperEncryptionService.new
  
      result = ""
      if params[:mode] == "encrypt"
        result = sv.encrypt(params[:input], params[:key])
      else
        result = sv.decrypt(params[:input], params[:key])
      end
  
      return result
    end
end