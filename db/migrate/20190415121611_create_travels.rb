class CreateTravels < ActiveRecord::Migration[5.2]
  def change
    create_table :travels do |t|
      t.string :title
      t.float :price
      t.float :rating
      t.string :date
      t.integer :duration
      t.text :description

      # t.belongs_to :type
      # t.belongs :from
      # t.integer :to

      t.timestamps
    end

    # add_foreign_key :travels, :cities, column: :from
    # add_foreign_key :travels, :cities, column: :to
  end
end
