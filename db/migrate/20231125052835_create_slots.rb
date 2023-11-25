class CreateSlots < ActiveRecord::Migration[7.0]
  def change
    create_table :slots do |t|
      t.integer :distance_tuple, array: true, default: [], null: false
      t.string :status

      t.timestamps
    end
  end
end
