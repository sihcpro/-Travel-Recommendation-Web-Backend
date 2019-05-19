module SessionsHelper
  def current_user
    response.request.env['HTTP_AUTH_TOKEN'] ? User.find_by(auth_token: response.request.env['HTTP_AUTH_TOKEN']) : nil
  end

  def current_user_test
    if response.request.env['HTTP_AUTH_TOKEN']
      User.find_by(auth_token: response.request.env['HTTP_AUTH_TOKEN'])
    elsif params[:auth_token]
      User.find_by(auth_token: params[:auth_token])
    end
  end

  def logged_in?
    session[:user_id] != nil
  end
end
