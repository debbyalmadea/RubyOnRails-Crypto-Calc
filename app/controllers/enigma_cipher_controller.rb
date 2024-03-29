class EnigmaCipherController < CipherController
  protected

  def _calculate(params)
    sv = EnigmaCipherService.new

    configuration = EnigmaConfiguration.new
    configuration.type = params[:type].to_i
    configuration.reflector = params[:rf].to_i
    configuration.plugboard = params[:pb]
    configuration.rotors = [params[:rt1].to_i, params[:rt2].to_i, params[:rt3].to_i]
    configuration.rotor_positions = [params[:rp1], params[:rp2], params[:rp3]]
    configuration.ring_settings = [params[:rs1], params[:rs2], params[:rs3]]

    result = ""
    if params[:mode] == "encrypt"
      result = sv.encrypt(params[:input], configuration)
    else
      result = sv.decrypt(params[:input], configuration)
    end

    return result
  end
end
