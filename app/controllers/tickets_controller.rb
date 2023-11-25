class TicketsController < ApplicationController

    def index
        @tickets = Ticket.all

        render json: @tickets
    end

    def create
        # create new ticket
        # status pending
        # time_in = time now
        # vehicle_plate = params vehicle_plate
        # vehicle_type = params S / M / L
        # entrance = params entrance
        # slot_id = ticket.get_nearest_slot
        # ticket.update_slot_status = occupied
        @ticket = Ticket.create(ticket_params)
        # @ticket.get_nearest_slot

        if @ticket.save
            render json: { message: 'Ticket has been created successfully' }
        else
            render json: { error: @ticket.errors.full_messages }
        end
    end

    def update
        # time_out = time now
        # amount = total_duration * rate
        # update status to paid
        # ticket.update_slot_status = available
    end


    private

    def ticket_params
        params.require(:ticket).permit(:vehicle_plate, :vehicle_type, :entrance)
    end
end