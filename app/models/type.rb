class Type < ApplicationRecord
  has_many :travel_types
  has_many :travels, through: :travel_type
end
