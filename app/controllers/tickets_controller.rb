class TicketsController < ApplicationController
    def index
        @tickets = Ticket.all

        render 'tickets/index'
    end

    def create
        @ticket = Ticket.create(ticket_params)

        if @ticket.save
            render 'tickets/create'
        else
            render json: { error: @ticket.errors.full_messages }
        end
    end

    def update
        @ticket = Ticket.find(params[:id])

        if @ticket.status === 'paid'
            render json: { message: 'Ticket already paid for' }
        else
            if @ticket.update(status: 'paid')
                @ticket.set_final_details
                @ticket.save
                render 'tickets/update'
            else
                render json: { error: @ticket.errors.full_messages }
            end
        end
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