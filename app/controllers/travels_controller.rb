class TravelsController < ApplicationController
  def create
  end

  def show
    @travel = Travel.find_by(travel_id_param)
    render json:  if @travel
                    @destinations = Destination.joins(:city).select("cities.name as destination").where(travel_id: params[:id]).map{|i| i.destination}
                    {
                      id: @travel.id,
                      title: @travel.title,
                      date: @travel.date,
                      duration: @travel.duration,
                      rating: @travel.rating,
                      price: @travel.price,
                      # start: @travel.start_name,
                      destinations: @destinations,
                      description: @travel.description,
                      status: 201
                    }
                  else
                    {
                      status: 404
                    }
                  end
  end

  def update
    user = current_user
    @travel = Travel.find_by(travel_id_param)
    render json:  if user.role == 'Admin'
                    if @travel
                      if @travel.update(travel_update_params)
                        {
                          travel: @travel,
                          status: 200
                        }
                      else
                        {
                          travel: @travel,
                          error: @travel.errors.full_messages,
                          status: 406
                        }
                      end
                    else
                      {
                        message: 'Travel not found!',
                        status: 404
                      }
                    end
                  else
                    {
                      message: "User isn't Admin",
                      status: 405
                    }
                  end
  end

  def destroy
    user = current_user
    user.role == 'Admin'
    @travel = Travel.find_by(travel_id_param)
    render json:  if user.role == 'Admin'
                    if @travel
                      if @travel.delete()
                        {
                          message: 'Success',
                          status: 200
                        }
                      else
                        {
                          error: @travel.errors.full_messages,
                          message: 'Fail',
                          status: 406
                        }
                      end
                    else
                      {
                        message: 'Travel not found!',
                        status: 404
                      }
                    end
                  else
                    {
                      message: "User isn't Admin",
                      status: 405
                    }
                  end
  end

  def travel_id_param
    params.permit(:id)
  end

  def travel_update_params
    params.permit(:title, :description, :price, :duration)
  end
end
