class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.datetime :started_at
      t.datetime :ended_at
      t.float :average_speed
      t.integer :vehicule_id
      t.integer :user_id
      t.integer :gps_id
      t.timestamps
    end
  end
end
