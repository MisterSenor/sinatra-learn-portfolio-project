require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "blah-blah-blah-bitty"
  end

  get '/' do
    "Welcome to the artist, works, and patrons database!"
  end

end
