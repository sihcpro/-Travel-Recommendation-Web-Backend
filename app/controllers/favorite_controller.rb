class FavoriteController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    if @user
      @favorite = @user.favorite
      if @favorite
        render json: {
          price: @favorite.price,
          date: @favorite.date,
          duration: @favorite.duration,
          status: 200
        }
      else
        render json: {
          message: 'User don\'t have any favorite',
          status: 204
        }
      end
    else
      render json: {
        message: 'Wrong user id',
        status: 400
      }
    end
  end
end
