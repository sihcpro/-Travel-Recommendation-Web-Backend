class Travel < ApplicationRecord
    validates :title, :price, presence: true

    has_one :start
    has_one :city, through: :start
    has_many :destination
    # belongs_to :cities, optional: true
    # belongs_to :cities, optional: true
end
