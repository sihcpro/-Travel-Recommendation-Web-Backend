class CreatePriceSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :price_steps do |t|
      t.string :name

      t.timestamps
    end
  end
end
