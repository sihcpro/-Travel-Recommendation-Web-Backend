class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table :cities do |t|
      t.string :name
      t.float :rating, :default => 3.0

      t.timestamps
    end
  end
end
