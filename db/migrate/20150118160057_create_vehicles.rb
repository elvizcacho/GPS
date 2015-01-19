class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :brand
      t.string :model
      t.string :license_plate
      t.integer :company_id

      t.timestamps
    end
  end
end
