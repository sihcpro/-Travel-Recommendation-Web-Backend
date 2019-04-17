class CreateStarts < ActiveRecord::Migration[5.2]
  def change
    create_table :starts do |t|
      t.belongs_to :travel
      t.belongs_to :city

      t.timestamps
    end
  end
end
