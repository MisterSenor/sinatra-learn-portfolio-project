class Work < ActiveRecord::Base
  belongs_to :artist
  belongs_to :patron
  belongs_to :user
end
