class SuggestionController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    if @user
      @suggestions = @user.suggestions
      if @suggestions
        render json: {
          suggestions: @suggestions.map{|item| item.travel_id},
          status: 200
        }
      else
        render json: {
          message: 'User don\'t have any suggestions',
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
