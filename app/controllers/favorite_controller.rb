class FavoriteController < ApplicationController
  def show
    @user = User.find_by(id: params[:user_id])
    render json: if @user
                   @favorites = FavoriteType.where(user_id: params[:user_id]).map(&:type_id)
                   if @favorite
                     {
                       favorites: @favorites,
                       message: 'Success',
                       status: 200
                     }
                   else
                     {
                       message: 'User don\'t have any favorite',
                       status: 204
                     }
                   end
                 else
                   {
                     message: 'Authentication failed',
                     status: 400
                   }
                 end
  end

  def create
    @user = User.find_by(id: params[:id])
    if @user
      save_all = true
      new_favorite_array.each do |favorite|
        favorite = FavoriteType.new(user_id: params[:user_id], favorite: favorite)
        save_all = false unless favorite.save
        errors = favorite.errors.full_messages
      end
      render json: if save_all
                     {
                       message: 'Success',
                       status: 201
                     }
                   else
                     {
                       error: favorite.errors.full_messages,
                       message: 'Failt!',
                       status: 406
                     }
                   end
    else
    render json: {
      message: 'Authentication failed',
      status: 400
    }
   end
  end

  def new_favorite_array
    params.permit(:favorites).split(',')
  end
end
