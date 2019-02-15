require './config/environment'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base

  register Sinatra::ActiveRecordExtension
  set :public_folder, 'public'
  set :session_secret, "CosimoDeMedici"
  set :views, 'app/views'
  enable :sessions
  register Sinatra::Flash

  get '/' do
    if !logged_in?
      erb :home
    else
      redirect to '/index'
    end
  end

  get '/index' do
    @user = User.find_by_id(session["user_id"])
    erb :index
  end

  helpers do
    def redirect_if_not_logged_in
      if !logged_in?
      redirect '/login'
      end
    end

    def logged_in?
    !!session[:user_id]
    end

    def current_user
      User.find(session["user_id"])
    end
  end

end
