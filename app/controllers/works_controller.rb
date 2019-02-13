class WorksController < ApplicationController

  get '/works' do
    redirect_if_not_logged_in
    @works = Work.all
    erb :'/works/index'
  end

  get '/works/new' do
    redirect_if_not_logged_in
    erb :'/works/new'
  end

  get '/works/error' do
    redirect_if_not_logged_in
    erb :'/works/error/error'
  end

  post '/works' do
    redirect_if_not_logged_in
    if params["work"]["name"] == nil || params["work"]["name"] == ""
      redirect to '/works/error'
    elsif params["work"]["year_completed"] == nil || params["work"]["year_completed"] == ""
      redirect to '/works/error'
    elsif params["work"]["artist"] == nil || params["work"]["artist"] == ""
      redirect to '/works/error'
    elsif params["work"]["patron"] == nil || params["work"]["patron"] == ""
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
    redirect_if_not_logged_in
    @work = Work.find_by_id(params["id"])
    erb :'/works/show'
  end

  get '/works/:id/edit' do
    redirect_if_not_logged_in
    @work = Work.find_by_id(params["id"])
    erb :'/works/edit'
  end

  patch '/works/:id' do
    redirect_if_not_logged_in
    @work = Work.find_by_id(params["id"])
    @work.update(name: params["work"]["name"], year_completed: params["work"]["year_completed"])
    @patron = Patron.find_by_id(@work.patron_id)
    @patron.update(name: params["work"]["patron"])
    @artist = Artist.find_by_id(@work.artist_id)
    @artist.update(name: params["work"]["artist"])
    erb :'/works/show'
  end

  delete '/works/:id/delete' do
    redirect_if_not_logged_in
    @work = Work.find_by_id(params["id"])
    @work.delete
    redirect to '/works'
  end


end
