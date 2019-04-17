class CreateDestinations < ActiveRecord::Migration[5.2]
  def change
    create_table :destinations do |t|
      t.belongs_to :travel
      t.belongs_to :city

      t.timestamps
    end
  end
end
