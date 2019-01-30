class UsersController < ApplicationController

  get '/signup' do
    erb :'/users/new'
  end

  post '/signup' do
    @user = User.create(username: params["username"], password: params["password"])
    @user.save
    session[:id] = @user.id
    redirect to '/index'
  end

  get '/login' do
    erb :'/users/login'
  end

  post '/login' do
    user = User.find_by_username(username: params["username"])
    if user && user.authenticate(params["password"])
      session[:user_id] = user.id
      redirect to '/index'
    else
      redirect to '/signup'
    end
  end

end
