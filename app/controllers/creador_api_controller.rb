class CreadorApiController < ActionController::API
    require 'scrapper.rb'
    queControlador('API')
    def hola
        @search = Search.create(name: params[:name])
        #render json: @search
        #redirect_to root_path
        #calling(params[:name])

        @data = clean(params[:name])
        
        @info = scraping(@data[:title])

        @final_data = hash_creator(@data[:keys], @info)
        @final_data = @final_data.sort_by {|hash| - hash[:percentage]}
        quant = @final_data.length
        puts "Se encontaron #{quant} en total."
        @prettyjson = {name: @data[:title].capitalize(), ans: @final_data}
        render json: @prettyjson
    end

    def adios
        render html: helpers.tag.strong("TESTEANDO LA API")
    end
end
