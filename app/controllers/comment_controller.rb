class CommentController < ApplicationController
  def index
    @comment = Comment.all
  end

  def create
    @comment = Comment.new(comment_create_params)
    render json:  if @comment.save()
                    {
                      message: 'Create success',
                      status: 201,
                    }
                  else
                    {
                      message: 'Create failt',
                      error: @comment.errors.full_messages,
                      status: 500
                    }
                  end
  end

  def show
    @comment = current_comment
    render json:  if @comment
                    {
                      comment: @comment,
                      message: 'Success',
                      status: 200
                    }
                  else
                    {
                      comment: @comment,
                      message: 'Comment not found',
                      status: 404
                    }
                  end
  end

  def update
    @comment = current_comment
    render json:  if @comment
                    if @comment.update(update_comment_params)
                      {
                        comment: @comment,
                        message: 'Update comment success',
                        status: 200
                      }
                    else
                      {
                        comment: @comment,
                        message: 'Fail to update!',
                        error: @comment.errors.full_messages,
                        status: 500
                      }
                    end
                  else
                    {
                      message: 'Comment not found!',
                      status: 404
                    }
                  end
  end

  def comment_create_params
    params.permit(:user_id, :travel_id, :content, :rating)
  end

  def current_comment
    Comment.find_by(id: params[:id]) if params[:id]
  end

  def update_comment_params
    params.permit(:rating, :content)
  end
end
