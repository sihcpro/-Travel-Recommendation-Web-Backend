class UserCommentsController < ApplicationController
  def show
    @comments = Comment.joins(:travel).select("comments.*", "travels.title as title").where(user_id: params[:id])
    render json:  if @comments
                    {
                      comments: @comments,
                      status: 200
                    }
                  else
                    {
                      message: 'No comments found!',
                      status: 204
                    }
                  end
  end
end
