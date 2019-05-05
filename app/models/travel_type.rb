class TravelType < ApplicationRecord
  belongs_to :type
  belongs_to :travel
end
