class TravelsController < ApplicationController
  def show
    # Travel.joins(:start => :city).select("travels.id as travel_id").first.travel_id
    @destinations_name = Destination.joins(:city
      ).select("travel_id",
               "cities.name as destination_name").order("travel_id")
    @destinations = {}
    @destinations_name.each do |item|
      if @destinations[item.travel_id]
        @destinations[item.travel_id] = @destinations[item.travel_id] + [item.destination_name]
      else
        @destinations[item.travel_id] = [item.destination_name]
      end
    end

    @travels = Travel.joins(:start => :city).select("travels.*", "cities.name as start_name").all
    travels = []
    @travels.each do |item|
      travel = item.attributes
      travel['destinations'] = @destinations[item.id]
      travels += [travel]
    end

    if params[:page]
      page = params[:page].to_i
      render json: {
        travels: travels[(page * 10)..((page + 1) * 10 - 1)],
        status: 201
      }
    else
      render json: {
        travels: travels,
        status: 201
      }
    end
  end
end
