class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.string :brand
      t.string :model
      t.string :placa
      t.integer :company_id

      t.timestamps
    end
  end
end
