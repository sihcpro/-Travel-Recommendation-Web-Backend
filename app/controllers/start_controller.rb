class StartController < ApplicationController
  def show
    if params[:id].match(/\d+/)
      @travels = City.find_by(id: params[:id]).travel()
    else
      @travels = City.find_by(name: params[:id]).travel()
    end

    render json: {
      travels: @travels,
      params: params
    }
  end
end
