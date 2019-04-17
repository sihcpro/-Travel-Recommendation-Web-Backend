class CreateDestinations < ActiveRecord::Migration[5.2]
  def change
    create_table :destinations do |t|
      t.belongs_to :city
      t.belongs_to :travel

      t.timestamps
    end
  end
end
