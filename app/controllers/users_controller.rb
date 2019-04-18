class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def create
    @user = User.new(user_create_params)
    render json:  if !User.find_by(user_email_params).nil?
                    { message: 'Conflict', status: 409 }
                  elsif @user.save
                    { message: 'Created', auth_token: @user.auth_token, id: @user.id, status: 201 }
                  else
                    { message: @user.errors.full_messages, status: 404 }
                  end
  end

  def show
    @user = User.find_by(user_id_params)
    render json:  if @user
                    { username: @user.username, gender: @user.gender, role: @user.role,
                      email: @user.email, status: 200 }
                  else
                    { message: 'Not found', status: 404 }
                  end
  end

  def update
    user = current_user
    message = if user
                if user.update(user_update_params)
                  { message: 'Accepted', status: 202 }
                else
                  { message: 'Failed', status: 406 }
                end
              else
                { message: 'Not found', status: 404 }
              end
    message['errors'] = user.errors.full_messages
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
end