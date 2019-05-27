class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def create
    @user = User.new(user_create_params)
    render json: if !User.find_by(user_email_params).nil?
                   {
                     message: 'Conflict',
                     status: 409
                   }
                 elsif @user.save
                   {
                     message: 'Created',
                     user: @user,
                     status: 201
                   }
                 else
                   { message: @user.errors.full_messages, status: 404 }
                 end
  end

  def show
    @user = User.find_by(user_id_params)
    favorites = FavoriteType.where(user_id: params[:id]).map(&:type_id)
    render json: if @user
                   {
                     username: @user.username,
                     gender: @user.gender, role: @user.role,
                     email: @user.email,
                     favorites: favorites,
                     message: 'Success',
                     status: 200
                   }
                 else
                   { message: 'Not found', status: 404 }
                 end
  end

  def update
    user = current_user
    message = if user
                if user.update(user_update_params)
                  FavoriteType.where(user_id: user.id).destroy_all
                  save_all = true
                  new_favorite_array().each do |favorite|
                    favorite = FavoriteType.new(user_id: user.id, type_id: favorite)
                    unless favorite.save
                      save_all = false
                      errors = favorite.errors.full_messages
                    end
                  end
                  if save_all
                    {
                      user: user,
                      message: 'Success',
                      status: 202
                    }
                  else
                    {
                      user: user,
                      message: 'Failed',
                      message_user: 'Success',
                      message_favorites: 'Failt',
                      errors: errors,
                      status: 400
                    }
                  end
                else
                  {
                    message: 'Failed',
                    errors: user.errors.full_messages,
                    status: 406
                  }
                end
              else
                { message: 'Not found', status: 404 }
              end
    render json: message
  end

  def destroy
    # User.delete(params[:id])
  end

  private

  def user_id_params
    params.permit(:id)
  end

  def user_email_params
    params.permit(:email)
  end

  def user_create_params
    params.permit(:username, :email, :gender, :password, :role)
  end

  def user_update_params
    params.permit(:username, :gender)
  end

  def new_favorite_array
    params[:favorites].split(',')
  end
end
