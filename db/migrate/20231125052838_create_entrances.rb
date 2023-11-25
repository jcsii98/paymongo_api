class CreateEntrances < ActiveRecord::Migration[7.0]
  def change
    create_table :entrances do |t|
      t.string :entrance_name

      t.timestamps
    end
  end
end
