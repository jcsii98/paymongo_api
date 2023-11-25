class CreateSlots < ActiveRecord::Migration[7.0]
  def change
    create_table :slots do |t|
      t.jsonb :distance_hash, default: {}, null: false
      t.string :slot_type
      t.string :status

      t.timestamps
    end
  end
end
