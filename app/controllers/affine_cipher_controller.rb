class AffineCipherController < CipherController
    protected 
  
    def _calculate(params)
      sv = AffineCipherService.new
  
      result = ""
      if params[:mode] == "encrypt"
        result = sv.encrypt(params[:input], params[:m].to_i, params[:b].to_i)
      else
        result = sv.decrypt(params[:input], params[:m].to_i, params[:b].to_i)
      end
  
      return result
    end
end