class CreateVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicles do |t|
      t.string :vehicle_type
      t.string :vehicle_plate

      t.timestamps
    end
  end
end
