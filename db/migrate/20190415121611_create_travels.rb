class CreateTravels < ActiveRecord::Migration[5.2]
  def change
    create_table :travels do |t|
      t.string :title
      t.string :lower_price
      t.string :upper_price
      t.string :address
      t.string :location
      t.string :link
      t.float :rating
      t.text :description

      # t.integer :duration
      # t.string :date
      # t.float :price
      # t.belongs_to :type
      # t.belongs :from
      # t.integer :to

      t.timestamps
    end

    # add_foreign_key :travels, :cities, column: :from
    # add_foreign_key :travels, :cities, column: :to
  end
end
