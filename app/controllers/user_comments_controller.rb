class UserCommentsController < ApplicationController
  def show
    @user = User.find_by(user_id_params)
    render json:  if @user
                    {
                      comments: @user.comments,
                      status: 200
                    }
                  else
                    {
                      message: 'Wrong user id!',
                      status: 204
                    }
                  end
  end

  def user_id_params
    params.permit(:id)
  end
end
