class Destination < ApplicationRecord
  belongs_to :travel
  belongs_to :city
end
