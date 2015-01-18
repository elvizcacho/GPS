class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :phone
      t.string :representative
      t.string :nit
      t.string :address
      t.string :email

      t.timestamps
    end
  end
end
