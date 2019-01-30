require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "CosimoDeMedici"
  end

  get '/' do
    erb :home
  end

  get '/index' do
    @user = User.find_by_id(session["id"])
    erb :index
  end

end
