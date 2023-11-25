class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.references :vehicle, null: false, foreign_key: true
      t.references :slot, null: false, foreign_key: true


      t.string :entrance_id
      t.datetime :time_in
      t.datetime :time_out
      t.integer :amount
      t.string :status

      t.timestamps
    end
  end
end
