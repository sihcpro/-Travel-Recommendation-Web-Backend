class SuggestionController < ApplicationController
  def show
    # @suggestions = Suggestion.joins(:travel).select("suggestions.*", "travels.*").where(user_id: params[:id])
    @suggestions = Suggestion.where(user_id: params[:id]).select("travel_id").map{|i| i.travel_id}
    render json:  if @suggestions
                    {
                      suggestions: @suggestions,
                      status: 200
                    }
                  else
                    render json: {
                      message: 'User don\'t have any suggestions',
                      status: 204
                    }
    end
  end
end
