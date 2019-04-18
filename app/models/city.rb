class City < ApplicationRecord
  has_many :starts
  has_many :travel, through: :starts
  has_many :destination
  has_many :travels, through: :destination
end
