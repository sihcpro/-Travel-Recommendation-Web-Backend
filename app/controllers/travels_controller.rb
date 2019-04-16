class TravelsController < ApplicationController
    validates :title, :price, presence: true
end
