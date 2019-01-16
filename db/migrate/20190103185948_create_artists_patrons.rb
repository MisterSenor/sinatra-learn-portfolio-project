class CreateArtistsPatrons < ActiveRecord::Migration[5.2]
  def change
    create_table :artists_patrons do |t|
      t.integer :artist_id
      t.integer :patron_id
    end 
  end
end
