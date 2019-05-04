class Travel < ApplicationRecord
    validates :title, :price, presence: true

    has_one :start
    has_one :city, through: :start
    has_one :type
    has_many :destinations
    has_many :cities, through: :destination
    has_many :histories
    has_many :comments
end
