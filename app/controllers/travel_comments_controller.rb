class TravelCommentsController < ApplicationController
  def show
    @travel = Travel.find_by(travel_id_params)
    render json:  if @travel
                    {
                      comments: @travel.comments,
                      status: 200
                    }
                  else
                    {
                      message: 'Wrong travel id!',
                      status: 204
                    }
                  end
  end

  def travel_id_params
    params.permit(:id)
  end
end
