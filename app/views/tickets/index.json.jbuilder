json.array! @tickets do |ticket|
    json.id ticket.id
    json.vehicle_plate ticket.vehicle_plate
    json.slot_id ticket.slot_id
    json.time_in ticket.time_in
    json.time_out ticket.time_out
    json.amount ticket.amount
    json.status ticket.status
end