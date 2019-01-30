class User < ActiveRecord::Base
  has_secure_password
  has_many :patrons
  has_many :artists
  has_many :works
end
