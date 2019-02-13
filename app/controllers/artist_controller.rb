
class ArtistController < ApplicationController

  get '/artists' do
    redirect_if_not_logged_in
    @artists = Artist.all
      if @artists.empty?
        erb :'/artists/none'
      else
        erb :'/artists/index'
      end
  end

  get '/artists/new' do
    redirect_if_not_logged_in
    erb :'/artists/new'
  end

  get '/artists/error' do
    redirect_if_not_logged_in
    erb :'/artists/error/error'
  end

  post '/artists/new' do
    redirect_if_not_logged_in
    if params["artist"]["name"] == nil || params["artist"]["name"] == ""
      redirect to '/artists/error'
    elsif params["artist"]["period"] == nil || params["artist"]["period"] == ""
      redirect to '/artists/error'
    elsif params["artist"]["style"] == nil || params["artist"]["style"] == ""
      redirect to '/artists/error'
    elsif Artist.find_by_name(params["artist"]["name"])
      @artist = Artist.find_by_name(params["artist"]["name"])
      redirect to "/artists/#{@artist.id}/edit"
    else
      @artist = Artist.create(name: params["artist"]["name"], period: params["artist"]["period"], style: params["artist"]["style"])
      if !params["work"]["name"].empty?
        @work = Work.create(name: params["work"]["name"], year_completed: params["work"]["year_completed"])
        @patron = Patron.find_or_create_by(name: params["work"]["patron"])
        @patron.works << @work
        @artist.works << @work
      end
    end
    if params["artist"]["work_ids"] && !params["artist"]["work_ids"].empty?
      params["artist"]["work_ids"].each do |id|
      @work = Work.find_by_id(id.to_i)
      @artist.works << @work
      end
    end
    redirect to '/artists'
  end

  get '/artists/:id' do
    redirect_if_not_logged_in
    @artist = Artist.find_by_id(params["id"])
      erb :'/artists/show'
  end

  get '/artists/:id/edit' do
    redirect_if_not_logged_in
    @artist = Artist.find_by_id(params["id"])
    erb :'/artists/edit'
  end

  patch '/artists/:id' do
    redirect_if_not_logged_in
    @artist = Artist.find_by_id(params["id"])
    @artist.update(name: params["artist"]["name"], period: params["artist"]["period"], style: params["artist"]["style"])
    if params["artist"]["work_ids"]
      @artist.works.clear
      params["artist"]["work_ids"].each do |work_id|
        @work = Work.find_by_id(work_id)
        @artist.works << @work
      end
    end
    if params["work"]["name"] != nil && params["work"]["name"] != ""
      @work = Work.create(name: params["work"]["name"] , year_completed: params["work"]["year_completed"])
      @patron = Patron.find_or_create_by(name: params["work"]["patron"])
      @patron.works << @work
      @artist.works << @work
    end
    erb :'/artists/show'
  end

  delete '/artists/:id/delete' do
    redirect_if_not_logged_in
    @artist = Artist.find_by_id(params["id"])
    @artist.delete
    redirect to '/artists'
  end

end
