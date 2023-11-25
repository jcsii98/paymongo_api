json.array! @slots_map do |slot|
    json.id slot.id
    json.slot_type slot.slot_type
    json.distance_hash slot.distance_hash
    json.status slot.status
end