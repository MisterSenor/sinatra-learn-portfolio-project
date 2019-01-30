class Patron < ActiveRecord::Base
  has_many :works
  has_many :artists, through: :artists_patrons
  belongs_to :user
end
