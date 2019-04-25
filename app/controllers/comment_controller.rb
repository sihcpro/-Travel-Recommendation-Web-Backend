class CommentController < ApplicationController
  def new
    @comment = Comment.new(comment_create_params)
  end

  def update
    @comment = current_comment
    if @comment
      if @comment.update(update_comment_params)
        render json: {
          comment: @comment,
          message: 'Update comment success',
          status: 200
        }
      else
        render json: {
          comment: @comment,
          message: 'Fail to update!',
          error: @comment.errors.full_messages,
          status: 500
        }
      end
    else
      render json: {
        message: 'Comment not found!',
        status: 204
      }
    end
  end

  def comment_create_params
    params.permit(:user_id, :travel_id, :content, :rating)
  end

  def current_comment
    if params[:id]
      Comment.find_by(id: params[:id])
    end
  end

  def update_comment_params
    params.permit(:rating, :content)
  end
end
