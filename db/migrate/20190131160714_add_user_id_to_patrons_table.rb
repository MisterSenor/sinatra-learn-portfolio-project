class AddUserIdToPatronsTable < ActiveRecord::Migration[5.2]
  def change
    add_column :patrons, :user_id, :integer
  end
end
