class CreateHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :histories do |t|
      t.belongs_to :user
      t.belongs_to :travel
      t.string :status

      t.timestamps
    end
  end
end
