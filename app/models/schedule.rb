class Schedule < ApplicationRecord
  validates :user_id, :travel_id, :order, presence: true

  belongs_to :user
  belongs_to :travel
end