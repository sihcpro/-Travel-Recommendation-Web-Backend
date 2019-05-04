class TravelsController < ApplicationController
  def show
    if params[:id]
      @travel = Travel.joins(:start => :city).select("travels.*", "cities.name as start_name").find_by(id: params[:id])
      render json:  if @travel
                      @destinations = Destination.joins(:city).select("cities.name as destination").where(travel_id: 10).map{|i| i.destination}
                      {
                        id: @travel.id,
                        title: @travel.title,
                        date: @travel.date,
                        duration: @travel.duration,
                        rating: @travel.rating,
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
    else
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

      render json:  if params[:page]
                      page = params[:page].to_i
                      {
                        travels: travels[(page * 10)..((page + 1) * 10 - 1)],
                        status: 201
                      }
                    else
                      {
                        travels: travels,
                        status: 201
                      }
                    end
    end
  end
end
