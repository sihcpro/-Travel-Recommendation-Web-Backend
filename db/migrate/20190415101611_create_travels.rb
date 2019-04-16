class CreateTravels < ActiveRecord::Migration[5.2]
  def change
    create_table :travels do |t|
      t.string :website
      t.string :title
      t.float :price
      t.string :start_pos
      t.string :end_pos
      t.datetime :start_time
      t.datetime :end_time
      t.string :link
      
      t.belongs_to :city, :from
      t.belongs_to :city, :to

      t.timestamps
    end

    add_index :cities, :from
    add_index :cities, :to
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
