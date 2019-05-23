class CreateEnvs < ActiveRecord::Migration[5.2]
  def change
    create_table :envs do |t|
      t.binary :lock
      t.binary :counts

      t.timestamps
    end
  end
end
