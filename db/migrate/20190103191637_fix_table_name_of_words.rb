class FixTableNameOfWords < ActiveRecord::Migration[5.2]
  def change
    rename_table :words, :works
  end
end
