class HistoryController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    if @user
      @histories = @user.histories
      if @histories
        render json: {
          histories: @histories,
          status: 200
        }
      else
        render json: {
          message: 'User don\'t have any histories',
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
