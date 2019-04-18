class Travel < ApplicationRecord
    validates :title, :price, presence: true

    has_one :start
    has_one :city, through: :start
    has_many :destination
    has_many :city, through: :destination
    has_many :history
end
