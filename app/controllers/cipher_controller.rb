require "base64"

# CipherController is a base class for all cipher controllers
class CipherController < ApplicationController
    def index 
    end

    def calculate
        input_type = params[:input_type]
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
            if params[:mode] == "decrypt"
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

        params[:input] = input
        result, other = _calculate(params)

        render json: { base64: Base64.encode64(result), mode: params[:mode], media_type: media_type, other: other}
    end

    protected 

    # _calculate is a method that should be implemented by the subclass
    # @Param [Hash] params the parameters for the calculation
    # @Return [String, Object] the result of the calculation and any other data that should be returned
    def _calculate(params)
        raise NotImplementedError
    end
end