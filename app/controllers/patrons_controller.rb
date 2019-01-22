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

  get '/patrons/errors/too_much_artist_input' do
    erb :'/patrons/errors/too_much_artist_input'
  end

  post '/patrons' do
    if params["work"]["artist_id"] && !params["artist"].empty?
      redirect to "/patrons/errors/too_much_artist_input"
    end
    if Patron.valid_params?(params)
      if params["work"]["artist_id"]
        #now make a patron with the pre-existing artist
        @patron = Patron.create(name: params["patron"])
        @work = Work.create(name: params["work"]["name"], year_completed: params["work"]["year_completed"])
        @patron.works << @work
        @artist = Artist.find_by_id(params["work"]["artist_id"][0])
        @artist.works << @work
        redirect to '/patrons'
      elsif params["artist"]
        #now create a new artist
        @patron = Patron.create(name: params["patron"])
        @work = Work.create(name: params["work"]["name"], year_completed: params["work"]["year_completed"])
        @artist = Artist.create(name: params["artist"])
        @artist.works << @work
        @patron.works << @work
        redirect to '/patrons'
      end
    else
      redirect to '/patrons/error'
    end
  end

    get '/patrons/:id' do
      @patron = Patron.find_by_id(params["id"])
      erb :'/patrons/show'
    end

    get '/patrons/:id/edit' do
      @patron = Patron.find_by_id(params["id"])
      erb :'/patrons/edit'
    end

end
