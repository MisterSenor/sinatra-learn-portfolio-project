class WorksController < ApplicationController

  get '/works' do
    @works = Work.all
    erb :'/works/index'
  end

  get '/works/new' do
    erb :'/works/new'
  end

  get '/works/error' do
    erb :'/works/error/error'
  end

  post '/works' do
    if params["work"]["name"] == nil || params["work"]["name"] == "" || params["work"]["name"] == /\s*/
      redirect to '/works/error'
    elsif params["work"]["year_completed"] == nil || params["work"]["year_completed"] == "" || params["work"]["year_completed"] == /\s*/
      redirect to '/works/error'
    elsif params["work"]["artist"] == nil || params["work"]["artist"] == "" || params["work"]["artist"] == /\s*/
      redirect to '/works/error'
    elsif params["work"]["patron"] == nil || params["work"]["patron"] == "" || params["work"]["patron"] == /\s*/
      redirect to '/works/error'
    else
      @work = Work.create(name: params["work"]["name"], year_completed: params["work"]["year_completed"])
      @artist = Artist.find_or_create_by(name: params["work"]["artist"])
      @artist.works << @work
      @patron = Patron.find_or_create_by(name: params["work"]["patron"])
      @patron.works << @work
      @work.save
      redirect to "/works"
    end
  end

  get '/works/:id' do
    @work = Work.find_by_id(params["id"])
    erb :'/works/show'
  end

  get '/works/:id/edit' do
    @work = Work.find_by_id(params["id"])
    erb :'/works/edit'
  end

  patch '/works/:id' do
    @work = Work.find_by_id(params["id"])
    @work.update(name: params["work"]["name"], year_completed: params["work"]["year_completed"])
    @patron = Patron.find_by_id(@work.patron_id)
    @patron.update(name: params["work"]["patron"])
    @artist = Artist.find_by_id(@work.artist_id)
    @artist.update(name: params["work"]["artist"])
    erb :'/works/show'
  end

  delete '/works/:id/delete' do
    @work = Work.find_by_id(params["id"])
    @work.delete
    redirect to '/works'
  end


end
