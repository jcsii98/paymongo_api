class Ticket < ApplicationRecord
    validates :vehicle_plate, presence: true
    validates :vehicle_type, presence: true
    validates :entrance, presence: true

    before_validation :set_ticket_details

    private

    def set_ticket_details
        self.get_nearest_slot
        self.set_time_in
    end

    def set_time_in
        # adjust time zone 
        self.time_in = Time.now
    end

    def get_nearest_slot
        available_slots = Slot.where(status: 'available')
        # puts "Available Slots: #{available_slots.inspect}"
        # where self.vehicle_type === M, slot.where(slot_type: MP || LP) where self.vehicle_type === L, slot.where(slot_type: LP)

        unless available_slots.all? { |slot| slot.distance_hash.key?(entrance) }
            errors.add(:base, "Invalid entrance value")
        end

        nearest_slot = available_slots.min_by { |slot| slot.distance_hash[entrance] }
        # puts "Nearest Slot: #{nearest_slot.inspect}"

        if nearest_slot
            self.slot_id = nearest_slot.id
        else
            errors.add(:base, "No slots found")
        end

        # return false only if there are errors
        errors.empty?
    end

end
