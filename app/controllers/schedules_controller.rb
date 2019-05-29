class SchedulesController < ApplicationController
  def create
    last_order = Schedule.where(user_id: params[:user_id]).select("max(rating) as  max")[0].max
    if last_order == nil
      schedule = Schedule.new()
  end

  def show

  end

  def update
  end

  def destroy
  end

  def 
end
