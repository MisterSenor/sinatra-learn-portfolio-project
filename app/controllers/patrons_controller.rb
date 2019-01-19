class PatronsController < ApplicationController

  get '/patrons' do
    @patrons = Patron.all
    erb :'/patrons/index'
  end

end
