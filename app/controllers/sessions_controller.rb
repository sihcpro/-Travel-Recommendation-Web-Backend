class SessionsController < ApplicationController
  def create
    @user = User.find_by(email_params)
    render json: if @user&.authenticate(params[:password])
                   @user.update_columns(auth_token: SecureRandom.hex)
                   {
                     id: @user.id,
                     auth_token: @user.auth_token,
                     username: @user.username,
                     role: @user.role,
                     status: 200
                   }
                 else
                   { message: 'Invalid email/password', status: 404 }
                 end
  end

  def destroy
    @user = current_user
    render json: if @user
                   @user.update_columns(auth_token: nil)
                   { message: 'You logged out!', status: 200 }
                 else
                   { message: 'Invalid user!', status: 404 }
                 end
  end

  private

  def email_params
    params.permit(:email)
  end
end
