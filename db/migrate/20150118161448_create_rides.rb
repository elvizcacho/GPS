class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.float :average_speed
      t.integer :vehicule_id
      t.integer :user_id
      t.integer :gps_id

      t.timestamps
    end
  end
end
