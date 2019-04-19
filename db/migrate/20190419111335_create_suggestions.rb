class CreateSuggestions < ActiveRecord::Migration[5.2]
  def change
    create_table :suggestions do |t|
      t.belongs_to :user
      t.belongs_to :travel
      t.float :rate

      t.timestamps
    end
  end
end
