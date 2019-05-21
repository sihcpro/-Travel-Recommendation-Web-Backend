class SuggestionsController < ApplicationController
  def show
    # @suggestions = Suggestion.joins(:travel).select("suggestions.*", "travels.*").where(user_id: params[:id])
    if params[:user_id]
      @suggestions = Suggestion.where(user_id: params[:user_id]).distinct.select('travel_id').map(&:travel_id)
    else
      @suggestions = Travel.order("rating DESC").limit(20).distinct.map(&:id)
    end
    render json: {
                   suggestions: @suggestions,
                   status: 200
                 }
  end
end
