class UsersController < ApplicationController

  get '/users/:id' do
    if !logged_in?
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
    if params["username"] == "" || params["username"] == nil || params["username"] == /\s*/
      redirect to '/signup'
    end
    if params["password"] == "" || params["password"] == nil || params["password"] == /\s*/
      redirect to '/signup'
    end
    if @user = User.find_by_username(params["username"])
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
      redirect to '/signup'
    end
  end

  post '/logout' do
    session.clear
    redirect to '/'
  end

end
