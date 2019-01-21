class Patron < ActiveRecord::Base
  has_many :works
  has_many :artists, through: :artists_patrons

  def self.valid_params?(params)
    return !params["patron"].empty? && !params["work"]["name"].empty? && !params["work"]["year_completed"].empty? && (params["work"]["artist_id"] != nil || !params["artist"].empty?)
  end

end
