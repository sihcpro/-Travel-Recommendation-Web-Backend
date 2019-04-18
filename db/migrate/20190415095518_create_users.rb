class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.string :location
      t.string :auth_token
      t.string :location
      t.integer :gender
      t.integer :role
      t.belongs_to :city

      t.timestamps
    end
  end
end
