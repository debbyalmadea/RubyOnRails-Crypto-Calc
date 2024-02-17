require "base64"

# CipherController is a base class for all cipher controllers
class CipherController < ApplicationController
    def index 
    end

    def calculate
        input_type = params[:input_type]
        key = params[:key]
        mode = params[:mode]
        input = ""
        media_type = ""

        if input_type == "Text"
            input = params[:input_text]
            if params[:text_type] == "base64"
                input = Base64.decode64(input)
            end
            media_type = "text/plain"
        else
            input = params[:input_file].read
            media_type = params[:input_file].content_type
            if mode == "decrypt"
                split = input.split(';base64,')
                puts split[0]
                if split.length > 1
                    input = split[1]
                    regex = /data:(?<mime_type>[^;]+)/
                    match = split[0].match(regex)
                    media_type = match[:mime_type]
                end
                input = Base64.decode64(input)
            end
        end

        result, other = _calculate(input, key, mode)

        render json: { base64: Base64.encode64(result), mode: mode, media_type: media_type, other: other}
    end

    protected 

    # _calculate is a method that should be implemented by the subclass
    # @Param input [String] the input to be encrypted or decrypted
    # @Param key [String] the key to be used for encryption or decryption
    # @Param mode [String] the mode of operation (encrypt or decrypt)
    # @Param media_type [String] the media type of the input
    # @Return [String, String] the result of the encryption or decryption and the MIME type of the result
    def _calculate(input, key, mode, media_type)
        raise NotImplementedError
    end
end