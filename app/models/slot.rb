class Slot < ApplicationRecord
    has_many :tickets, dependent: :destroy

end
