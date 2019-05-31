class SchedulesController < ApplicationController
  def create
    last_order = Schedule.where(user_id: params[:user_id]).select("max(schedules.order) as max_order")[0].max_order
    last_order = 0 if last_order == nil
    schedule = Schedule.new(create_schedule_params)
    schedule.order = last_order + 1
    render json: if schedule.save
                   {
                     schedule: schedule,
                     message: 'Success',
                     status: 200
                   }
                 else
                   {
                     schedule: schedule,
                     errors: schedule.errors.full_messages,
                     message: 'Failt',
                     status: 409
                   }
                 end
  end

  def show
    schedules = Schedule.where(user_id: params[:user_id]).order(:order)
    render json: {
      schedules: schedules,
      message: 'Success',
      status: 200
    }
  end

  def update
    schedule_ids = update_schedule_params()
    update_status = true
    Schedule.transaction do
      enumerate(schedule_ids).each do |order, id|
        status = Schedule.find_by(id: id).update(order: order)
      end
    end
    render json: if update_status
                   {
                     message: 'Success',
                     status: 200
                   }
                 else
                   {
                     message: 'Failt',
                     status: 400
                   }
                 end
  end

  def destroy
    schedule = Schedule.find_by(destroy_schedule_params)
    render json: if schedule
                   if schedule.delete
                     {
                       message: 'Success',
                       status: 200
                     }
                   else
                     {
                       message: 'Failt',
                       status: 400
                     }
                   end
                 else
                   {
                     message: 'Not found!',
                     status: 404
                   }
                 end
  end

  def create_schedule_params
    params.permit(:user_id, :travel_id)
  end

  def update_schedule_params
    if params[:schedules]
      params[:schedules].split(',')
    else
      []
    end
  end

  def destroy_schedule_params
    params.permit(:user_id, :id)
  end
end
