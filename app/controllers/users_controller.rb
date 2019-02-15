class UsersController < ApplicationController

  get '/users/:id' do
    if !logged_in?
      flash[:message] = "You have to be logged in to do that."
      redirect to '/login'
    end
    @user = User.find(params[:id])
    if !@user.nil? && @user == current_user
      erb :'users/show'
    else
      redirect '/login'
    end
  end

  get '/signup' do
    erb :'/users/new'
  end

  post '/signup' do
    if params["username"] == "" || params["username"] == nil
      flash[:message] = "Your username/password cannot be blank."
      redirect to '/signup'
    end
    if params["password"] == "" || params["password"] == nil
      flash[:message] = "Your username/password cannot be blank."
      redirect to '/signup'
    end
    if @user = User.find_by_username(params["username"])
      flash[:message] = "Your username already exists.  Please login rather than signing up."
      redirect to '/login'
    else
    @user = User.create(username: params["username"], password: params["password"])
    @user.save
    session[:user_id] = @user.id
    redirect to '/index'
    end
  end

  get '/login' do
    erb :'/users/login'
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect to '/index'
    else
      flash[:message] = "You need to signup before you can login."
      redirect to '/signup'
    end
  end

  post '/logout' do
    session.clear
    redirect to '/'
  end

end
