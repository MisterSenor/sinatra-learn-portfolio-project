class PatronsController < ApplicationController

  get '/patrons' do
    @patrons = Patron.all
    erb :'/patrons/index'
  end

  get '/patrons/new' do
    erb :'/patrons/new'
  end

  get '/patrons/errors/error' do
    erb :'/patrons/errors/error'
  end

  post '/patrons' do
    if params["work"]["artist_id"] && params["artist"]
      erb :'/patrons/errors/too_much_artist_input'
    elsif Patron.valid_params?(params)
      if params["work"]["artist_id"] ####this is not finished yet
      redirect to '/patrons'
      end 
    else
      redirect to '/patrons/error'
    end
  end

    get '/patrons/:id/edit' do
      @patron = Patron.find_by_id(params["id"])
      erb :'/patrons/edit'
    end

end
