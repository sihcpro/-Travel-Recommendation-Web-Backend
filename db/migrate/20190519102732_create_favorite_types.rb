class CreateFavoriteTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :favorite_types do |t|
      t.belongs_to :user
      t.belongs_to :type

      t.timestamps
    end
  end
end
