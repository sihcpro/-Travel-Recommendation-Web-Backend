class Travel < ApplicationRecord
    validates :title, :price, presence: true

    # has_one :start
    # has_one :city, through: :start
    has_many :destinations
    has_many :cities, through: :destination
    has_many :histories
    has_many :comments
    has_many :travel_types
    has_many :types, through: :travel_type
end
