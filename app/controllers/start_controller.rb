class StartController < ApplicationController
  def show
    @travels = if /\d+/.match?(params[:id])
                 City.find_by(id: params[:id]).travel
               else
                 City.find_by(name: params[:id]).travel
               end

    render json: {
      travels: @travels,
      params: params
    }
  end
end
