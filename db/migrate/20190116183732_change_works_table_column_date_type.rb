class ChangeWorksTableColumnDateType < ActiveRecord::Migration[5.2]
  def change
    change_column :works, :year_completed, :string
  end
end
