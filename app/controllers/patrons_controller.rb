class PatronsController < ApplicationController

  get '/patrons' do
    redirect_if_not_logged_in
    @patrons = Patron.all
    erb :'/patrons/index'
  end

  get '/patrons/new' do
    redirect_if_not_logged_in
    erb :'/patrons/new'
  end

  get '/patrons/errors/error' do
    redirect_if_not_logged_in
    erb :'/patrons/errors/error'
  end

  get '/patrons/errors/too_much_artist_input' do
    redirect_if_not_logged_in
    erb :'/patrons/errors/too_much_artist_input'
  end

  post '/patrons/new' do
    redirect_if_not_logged_in
    if params["patron_name"] == "" || params["patron_name"] == nil
      flash[:message] = "Your patron must have a name."
      redirect to '/patrons/new'
    elsif params["work"]["name"] == nil || params["work"]["name"] == ""
      flash[:message] = "Your patron must have a work with a name."
      redirect to '/patrons/new'
    elsif params["work"]["year_completed"] == nil || params["work"]["year_completed"] == ""
      flash[:message] = "You must include the year of completion for this work."
      redirect to '/patrons/new'
    elsif (params["artist"] == nil || params["artist"] == "") && !params["work"]["artist_id"]
      flash[:message] = "You patron must either be associated with a current artist or you must create a new one."
      redirect to '/patrons/new'
    else
    @patron = Patron.create(name: params["patron_name"], user_id: session["user_id"])
    @work = Work.create(name: params["work"]["name"], year_completed: params["work"]["year_completed"], user_id: session["user_id"])
      if params["work"]["artist_id"] != nil
        @artist = Artist.find_by_id(params["work"]["artist_id"])
        @work.artist = @artist
        @patron.works << @work
        @artist.works << @work
      else
        @artist = Artist.create(name: params["artist"], user_id: session["user_id"])
        @work.artist = @artist
        @patron.works << @work
        @artist.works << @work
      end
    redirect to "/patrons"
    end
  end

  get '/patrons/:id' do
    redirect_if_not_logged_in
    @patron = Patron.find_by_id(params["id"])
    erb :'/patrons/show'
  end

  get '/patrons/:id/edit' do
    redirect_if_not_logged_in
    @patron = Patron.find_by_id(params["id"])
    if @patron.user_id != current_user.id
      flash[:message] = "You cannot edit this patron since you did not create it."
      redirect to '/patrons'
    end
    erb :'/patrons/edit'
  end

  patch '/patrons/:id' do
    redirect_if_not_logged_in
    @patron = Patron.find_by_id(params["id"])
    @patron.update(name: params["patron_name"])
  #below this line should read: "if there's no new artist name and there are no checkboxes for artists checked"
  #In other words, if you want to change the works that belong to a patron, but not create any new works
    if params["artist"].empty? && params["patron_works"]["artist_id"] == nil
      new_work_array = []
      params["patron_works"]["work_ids"].each do |work|
        @work = Work.find_by_id(work)
        new_work_array << @work
      end
      @patron.works = @patron.works.reject{|x| !new_work_array.include?(x)}
    end
    if !params["work"]["name"].empty?#the params form with a new work name isn't empty
      @work = Work.create(name: params["work"]["name"], year_completed: params["work"]["year_completed"], user_id: session["user_id"])
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

  delete '/patrons/:id/delete' do
    redirect_if_not_logged_in
    @patron = Patron.find_by_id(params["id"])
    if @patron.user_id == current_user.id
      @patron.destroy
      redirect to '/patrons'
    else
      flash[:message] = "You cannot delete this patron since you did not create it."
      redirect to '/patrons'
    end
  end


end
