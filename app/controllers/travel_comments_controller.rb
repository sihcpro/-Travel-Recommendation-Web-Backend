class TravelCommentsController < ApplicationController
  def show
    @comments = Comment.joins(:user).select("comments.*", "users.username as username").where(travel_id: params[:id])
    render json:  if @comments
                    {
                      comments: @comments,
                      status: 200
                    }
                  else
                    {
                      message: 'Wrong travel id!',
                      status: 204
                    }
                  end
  end
end
