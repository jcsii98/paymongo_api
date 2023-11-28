class SlotsController < ApplicationController

    def index
        @slots_map = Slot.all

        render 'slots/index'
    end

    def create
        # create from parking map array
        # e.g. [{ "distance_hash": { "entrance_A": 10, "entrnace_B": 20, "entrance_C": 30}, "status" "available" }, { "distance_hash": { "entrance_A": 15, "entrance_B": 25, "entrance_C": 35 }, "status": "occupied" }, { "distance_hash": { "entrance_A": 8, "entrance_B": 18, "entrance_C": 28 }, "status": "available" }]

        # check if a map already exists
        slots_map = Slot.all

        if slots_map.length > 0
            render json: { message: 'A parking map already exists' }
        else
            slots_array = params[:slots_array]

            slots_array.each do |slot_data|
                distance_hash = slot_data['distance_hash']
                slot_type = slot_data['slot_type']
                status = slot_data['status']

                Slot.create(distance_hash: distance_hash, slot_type: slot_type, status: status)
            end
            render json: { message: 'Slots created successfully!'}
        end
    end

    # test endpoint to check nearest available slot
    def show_nearest
        available_slots = Slot.where(status: 'available')

        vehicle_type = params[:show_slot][:vehicle_type]

        if vehicle_type === 'M'
            filtered_slots = available_slots.reject { |slot| slot.slot_type === 'SP'}
        elsif vehicle_type === 'L'
            filtered_slots = available_slots.select { |slot| slot.slot_type === 'LP' }
        else
            filtered_slots = available_slots
        end

        
        unless filtered_slots.all? { |slot| slot.distance_hash.key?(params[:show_slot][:entrance])}
            render json: { error: "Entrance value does not exist" }
        end

        @nearest_slot = filtered_slots.min_by { |slot| slot.distance_hash[params[:show_slot][:entrance.to_s]] }
        
        if @nearest_slot
            render 'slots/show_nearest'
        else
            render json: { error: "No slots found" }
        end
    end

    def destroy_map
        Slot.destroy_all

        render json: { message: 'Parking map has been deleted' }
    end

    private

    def show_slot_params
        params.require(:show_slot).permit(:vehicle_type, :entrance)
    end
end