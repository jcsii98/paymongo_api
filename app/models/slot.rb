class Slot < ApplicationRecord
    has_many :tickets, dependent: :destroy

    def update_slot_status
        if self.status === 'available'
            update(status: 'occupied')
        else
            update(status: 'available')
        end
    end
end
