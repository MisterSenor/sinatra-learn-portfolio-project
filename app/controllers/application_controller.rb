require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "blah-blah-blah-bitty"
  end

  get '/' do
    erb :index
  end

end
