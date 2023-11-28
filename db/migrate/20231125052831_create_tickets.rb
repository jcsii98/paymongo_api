class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.string :vehicle_plate
      t.string :vehicle_type

      t.string :entrance
      t.datetime :time_in
      t.datetime :time_out
      t.integer :amount
      t.string :status, default: "pending", null: false

      t.timestamps
    end
  end
end
