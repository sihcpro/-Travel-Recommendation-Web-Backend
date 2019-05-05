class CreateTravelTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :travel_types do |t|
      t.belongs_to :travel
      t.belongs_to :type

      t.timestamps
    end
  end
end
