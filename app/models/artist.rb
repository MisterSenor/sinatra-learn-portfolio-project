class Artist < ActiveRecord::Base
  has_many :works
  has_many :patrons, through: :artists_patrons
end
