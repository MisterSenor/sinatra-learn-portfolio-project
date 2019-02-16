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
      flash[:message] = "Your work needs a name."
      redirect to '/works/new'
    elsif params["work"]["year_completed"] == nil || params["work"]["year_completed"] == ""
      flash[:message] = "Your works needs a year of completion."
      redirect to '/works/new'
    elsif params["work"]["artist"] == nil || params["work"]["artist"] == ""
      flash[:message] = "Your work needs an artist."
      redirect to '/works/new'
    elsif params["work"]["patron"] == nil || params["work"]["patron"] == ""
      flash[:message] = "Your work needs a patron."
      redirect to '/works/new'
    elsif Work.find_by_name(params["work"]["name"])
      @work = Work.find_by_name(params["work"]["name"])
      redirect to "/works/#{@work.id}/edit"
    else
      @work = Work.create(name: params["work"]["name"], year_completed: params["work"]["year_completed"], user_id: session["user_id"])
      @artist = Artist.find_or_create_by(name: params["work"]["artist"])
      @artist.user_id = session["user_id"]
      @artist.works << @work
      @patron = Patron.find_or_create_by(name: params["work"]["patron"])
      @patron.user_id = session["user_id"]
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
    if @work.user_id != current_user.id
      flash[:message] = "You cannot edit this work since you did not create it."
      redirect to '/works'
    end
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
    if @work.user_id == current_user.id
      @work.destroy
      redirect to '/works'
    else
      flash[:message] = "You cannot delete this work since you did not create it."
      redirect to '/works'
    end
  end


end
