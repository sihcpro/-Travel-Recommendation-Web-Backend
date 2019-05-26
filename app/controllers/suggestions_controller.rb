class SuggestionsController < ApplicationController
  def show
    @suggestions = nil
    if params[:user_id]
      @suggestions = Suggestion.where(user_id: params[:user_id]).distinct.select('travel_id').map(&:travel_id)
    end
    if !@suggestions
      @suggestions = Travel.order("rating DESC").limit(20).distinct.map(&:id)
    end
    render json: {
                   suggestions: @suggestions,
                   status: 200
                 }
  end
end
