class AddSlotToTickets < ActiveRecord::Migration[7.0]
  def change
    add_reference :tickets, :slot, foreign_key: true
  end
end
