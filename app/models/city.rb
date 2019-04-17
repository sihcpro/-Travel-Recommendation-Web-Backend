class City < ApplicationRecord
  has_many :start
  has_many :travels, through: :start
  has_many :destination
  has_many :travels, through: :destination
end
