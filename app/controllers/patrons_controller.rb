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

  post '/patrons/new' do
    @patron = Patron.create(name: params["patron_name"])
    @work = Work.create(name: params["work"]["name"], year_completed: params["work"]["year_completed"])
    if params["work"]["artist_id"] != nil
      @artist = Artist.find_by_id(params["work"]["artist_id"])
      @work.artist = @artist
      @patron.works << @work
      @artist.works << @work
    else
      @artist = Artist.create(name: params["artist"])
      @work.artist = @artist
      @patron.works << @work
      @artist.works << @work
    end
    redirect to "/patrons"
  end

  get '/patrons/:id' do
    @patron = Patron.find_by_id(params["id"])
    erb :'/patrons/show'
  end

  get '/patrons/:id/edit' do
    @patron = Patron.find_by_id(params["id"])
    erb :'/patrons/edit'
  end

  patch '/patrons/:id' do
    @patron = Patron.find_by_id(params["id"])
    @patron.update(name: params["patron_name"])
  #on line 52, "if there's no new artist name and there are no checkboxes for artists checked"
    if params["artist"].empty? && params["patron_works"]["artist_id"] == nil
      new_work_array = []
      params["patron_works"]["work_ids"].each do |work|
        new_work_array << work.to_i
      end
      old_work_array = []
      @patron.works.each do |work|
        old_work_array << work
      end
      deleted_work = old_work_array - new_work_array
      @work = Work.find_by_id(deleted_work)
      @patron.works - @work
    end
    if !params["work"]["name"].empty?#the params form with a new work name isn't empty
      @work = Work.create(name: params["work"]["name"], year_completed: params["work"]["year_completed"])
      if params["patron_works"].keys.include?("artist_id")
        @artist = Artist.find_by_id(params["patron_works"]["artist_id"])
        @work.artist = @artist
        @artist.works << @work
      else
        @artist = Artist.create(name: params["artist"])
        @work.artist = @artist
        @artist.works << @work
      end
      @patron.works << @work
    end
    redirect to "/patrons"
  end


end
