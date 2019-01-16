class AddYearCompletedColumnToWorks < ActiveRecord::Migration[5.2]
  def change
    add_column :works, :year_completed, :integer
  end
end
