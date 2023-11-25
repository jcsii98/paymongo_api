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

    def destroy_map
        Slot.destroy_all

        render json: { message: 'Parking map has been deleted' }
    end

    private

    # def slot_params(distance_hash, status)
    #     { distance_hash: distance_hash, status: status }
    # end
end