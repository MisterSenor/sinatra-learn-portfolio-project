
class ArtistController < ApplicationController

  get '/artists' do
    #index action
    @artists = Artist.all
      if @artists.empty?
        erb :'/artists/none'
      else
        erb :'/artists/index'
      end
  end

  get '/artists/new' do
    erb :'/artists/new'
  end

  get '/artists/error' do
    erb :'/artists/error/error'
  end

  post '/artists/new' do
    if params["artist"]["name"] == nil || params["artist"]["name"] == "" || params["artist"]["name"] == /\s*/
      redirect to '/artists/error'
    elsif params["artist"]["period"] == nil || params["artist"]["period"] == "" || params["artist"]["period"] == /\s*/
      redirect to '/artists/error'
    elsif params["artist"]["style"] == nil || params["artist"]["style"] == "" || params["artist"]["style"] == /\s*/
      redirect to '/artists/error'
    elsif Artist.find_by_name(params["artist"]["name"])
      @artist = Artist.find_by_name(params["artist"]["name"])
      redirect to "/artists/#{@artist.id}/edit"
    else
      @artist = Artist.create(name: params["artist"]["name"], period: params["artist"]["period"], style: params["artist"]["style"])
      if !params["work"].empty?
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
    @artist = Artist.find_by_id(params["id"])
      erb :'/artists/show'
  end

  get '/artists/:id/edit' do
    @artist = Artist.find_by_id(params["id"])
    erb :'/artists/edit'
  end

  patch '/artists/:id' do
    @artist = Artist.find_by_id(params["id"])
    @artist.update(name: params["artist"]["name"], period: params["artist"]["period"], style: params["artist"]["style"])
    erb :'/artists/show'
  end

  delete '/artists/:id/delete' do
    @artist = Artist.find_by_id(params["id"])
    @artist.delete
    redirect to '/artists'
  end

end
