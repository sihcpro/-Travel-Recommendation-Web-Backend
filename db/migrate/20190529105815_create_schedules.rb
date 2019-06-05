class CreateSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules do |t|
      t.belongs_to :user
      t.belongs_to :travel
      t.integer :order

      t.timestamps
    end
  end
end
