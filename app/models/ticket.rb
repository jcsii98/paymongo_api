class Ticket < ApplicationRecord
    belongs_to :slot, optional: true
    validates :vehicle_plate, presence: true, uniqueness: { scope: :status, conditions: -> { where(status: 'pending')} }
    validates :vehicle_type, presence: true
    validates :entrance, presence: true
    validates :time_in, presence: true

    before_validation :set_initial_details, on: :create

    def set_final_details
        if set_time_out
            set_amount
            set_slot_status_to_available
        end
    end

    private

    # time values for testing
    def time_now
        # uncomment the desired timestamp before running post / patch

        # #  # # # # # non-overlapping ticket
        # first in dec 2, 00:00:00
        DateTime.new(2023, 12, 2, 0, 0, 0)

        # first out dec 2, 12:30:00
        # DateTime.new(2023, 12, 2, 12, 30, 0)

        # second in dec 2, 14:00:00
        # DateTime.new(2023, 12, 2, 14, 0, 0)

        # second out dec 3, 00:00:00
        # DateTime.new(2023, 12, 3, 0, 0, 0)

        # third in dec 3, 02:00:00
        # DateTime.new(2023, 12, 3, 2, 0, 0)

        # third out dec 3, 03:00:00
        # DateTime.new(2023, 12, 3, 3, 0, 0)

        # # # # # # # overlapping ticket
        # first in dec 4, 00:00:00
        # DateTime.new(2023, 12, 4, 0, 0, 0)

        # first out dec 4, 12:30:00
        # DateTime.new(2023, 12, 4, 12, 30, 0)

        # second in dec 4, 13:00:00
        # DateTime.new(2023, 12, 4, 13, 0, 0)
        
        # second out dec 4, 15:00:00
        # DateTime.new(2023, 12, 4, 15, 0, 0)
    end

    # fetch existing ticket
    def existing_ticket
        Ticket.where(vehicle_plate: vehicle_plate).where.not(id: self.id).order(time_out: :desc).first
    end

    # INITIAL TICKET DETAILS PRE-PAYMENT

    def set_initial_details
        puts "Existing Ticket: #{existing_ticket.inspect}"

        if get_nearest_slot
            if existing_ticket && existing_ticket.time_out && existing_ticket.time_out >= (time_now - 1.hour)
                self.time_in = existing_ticket.time_in
            else
                set_time_in # set time_in = time.now
            end
            set_slot_status_to_occupied
        end
    end

    def set_time_in
        self.time_in = time_now
    end

    def get_nearest_slot
        available_slots = Slot.where(status: 'available')

        if vehicle_type === 'M'
            filtered_slots = available_slots.reject { |slot| slot.slot_type === 'SP' }
        elsif vehicle_type === 'L'
            filtered_slots = available_slots.select { |slot| slot.slot_type === 'LP' }
        else
            filtered_slots = available_slots
        end

        unless filtered_slots.all? { |slot| slot.distance_hash.key?(entrance) }
            errors.add(:base, "Invalid entrance value")
            return false
        end

        nearest_slot = filtered_slots.min_by { |slot| slot.distance_hash[entrance] }
        puts "Nearest Slot: #{nearest_slot.inspect}"

        if nearest_slot
            self.slot = nearest_slot
            puts "Self: #{self.inspect}"
        else
            errors.add(:base, "No slots found")
            return false
        end

        errors.empty?
    end

    def set_slot_status_to_occupied
        slot = self.slot
        slot.status = 'occupied'
        slot.save!
    end

    # FINAL TICKET DETAILS POST-PAYMENT

    def set_slot_status_to_available
        slot = self.slot
        slot.status = 'available'
        slot.save!
    end

    def set_time_out
        self.time_out = time_now
    end

    def set_amount
        # determine ticket rate
        slot = self.slot
        slot_type = slot.slot_type

        if slot_type === 'LP'
            rate = 100
        elsif slot_type === 'MP'
            rate = 60
        else
            rate = 20
        end

        flat_rate = 40

        # check if existing_ticket
        puts "Existing Ticket: #{existing_ticket.inspect}"

        if existing_ticket && existing_ticket.time_in === self.time_in
            puts "Overlapping ticket... running dynamic computation"

            existing_time_in = self.time_in.to_datetime
            time_in = existing_ticket.time_out.to_datetime
            time_out = self.time_out.to_datetime
            duration_in_hours = ((time_out - existing_time_in) * 24).ceil

            new_ticket_duration_in_hours = ((time_out - time_in) * 24).ceil

            if duration_in_hours <= 3
                total_amount = 0
            elsif duration_in_hours >= 24
                overnight_chunks = (duration_in_hours / 24).floor
                overnight_amount = 5000 * overnight_chunks

                overnight_hours = overnight_chunks * 24
                remainder_hours = (duration_in_hours - overnight_hours).ceil
                remainder_amount = remainder_hours * rate
                total_amount = overnight_amount + remainder_amount - existing_ticket.amount
            else
                hourly_amount = new_ticket_duration_in_hours * rate
                total_amount = hourly_amount
            end
        else
            time_in = self.time_in.to_datetime
            time_out = self.time_out.to_datetime

            duration_in_hours = ((time_out - time_in) * 24).ceil

            if duration_in_hours <= 3
                total_amount = flat_rate
            elsif duration_in_hours >= 24
                overnight_chunks = (duration_in_hours / 24).floor
                overnight_amount = 5000 * overnight_chunks

                overnight_hours = overnight_chunks * 24
                remainder_hours = (duration_in_hours - overnight_hours).ceil
                remainder_amount = remainder_hours * rate

                total_amount = overnight_amount + remainder_amount
            else
                hourly_amount = ( duration_in_hours - 3 ) * rate
                total_amount = flat_rate + hourly_amount
            end
        end
        
        self.amount = total_amount
    end
end
