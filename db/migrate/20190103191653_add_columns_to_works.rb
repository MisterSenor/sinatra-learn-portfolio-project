class AddColumnsToWorks < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :artist_id, :integer
    add_column :works, :patron_id, :integer
  end
end
