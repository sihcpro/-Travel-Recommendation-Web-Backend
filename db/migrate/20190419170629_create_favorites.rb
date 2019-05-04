class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.belongs_to :user
      t.string :price
      t.string :date
      t.integer :duration
      t.integer :type

      t.timestamps
    end
  end
end
