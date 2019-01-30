class Artist < ActiveRecord::Base
  has_many :works
  has_many :patrons, through: :artists_patrons
  belongs_to :user
end
