class Travel < ApplicationRecord
  validates :title, presence: true

  # has_one :start
  # has_one :city, through: :start
  has_many :destinations
  has_many :cities, through: :destination
  has_many :histories
  has_many :comments
  has_many :travel_types
  has_many :types, through: :travel_types
  has_many :schedules

  def update_rating
    rate = ActiveRecord::Base.connection.execute("SELECT SUM(comments.rating) AS total, count(*) AS count FROM comments WHERE comments.travel_id = #{self.id} GROUP BY comments.travel_id")
    return self.update(rating: rate.first["total"] * 1.0 / rate.first["count"])
  end
end
