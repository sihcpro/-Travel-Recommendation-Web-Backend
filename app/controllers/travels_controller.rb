class TravelsController < ApplicationController
  def show
    @travels = Travel.all
    @result = []
    @travels.each do |travel|
      @destinations = travel.destination
      @cities = []
      for @destination in @destinations
        @cities += [@destination.city.name]
      end
      @start = travel.start
      if @start
        @start = @start.city.name
      end
      @result += [{
        id: travel.id,
        title: travel.title,
        date: travel.date,
        duration: travel.duration,
        start: @start,
        destinations: @cities
      }]
    end
    render json: {
      travels: @result,
      status: 201
    }
  end
end
