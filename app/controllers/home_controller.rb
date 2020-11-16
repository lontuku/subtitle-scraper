class HomeController < ApplicationController
  require 'scrapper.rb'

  def index
    ::Saludos::Saludando.saludo('Probando codigo externo')
    @search = Search.new
    @searches = Search.all
    if params[:name] != nil
      Search.create(name: params[:name])
    end 
    #saludo(Search.last.name)
    queControlador('home')
  end
end
