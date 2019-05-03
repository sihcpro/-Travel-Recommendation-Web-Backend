class TravelController < ApplicationController
  def show
    @travel = Travel.joins(:start => :city).select("travels.*", "cities.name as start_name").find_by(id: params[:id])
    render json:  if @travel
                    @destinations = Destination.joins(:city).select("cities.name as destination").where(travel_id: 10).map{|i| i.destination}
                    {
                      id: @travel.id,
                      title: @travel.title,
                      date: @travel.date,
                      duration: @travel.duration,
                      price: @travel.price,
                      start: @travel.start_name,
                      destinations: @destinations,
                      status: 201
                    }
                  else
                    {
                      status: 404
                    }
                  end
  end
end
