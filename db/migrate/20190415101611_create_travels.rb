class CreateTravels < ActiveRecord::Migration[5.2]
  def change
    create_table :travels do |t|
      t.string :title
      t.float :price
      t.float :rating
      t.datetime :start_time
      t.datetime :duration
      t.text :description

      # t.belongs :from
      # t.integer :to

      t.timestamps
    end

    # add_foreign_key :travels, :cities, column: :from
    # add_foreign_key :travels, :cities, column: :to
  end
end

# 'website',
# 'name',
# 'price',
# 'start_pos',
# 'end_pos',
# 'start_time',
# 'end_time',
# 'link'
