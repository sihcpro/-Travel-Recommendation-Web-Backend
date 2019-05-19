class TravelTypesController < ApplicationController
  def create
    travel_type = TravelType.new(travel_type_params)
    render json: if travel_type.save
                   {
                     travel_type: travel_type,
                     message: 'Success',
                     status: 200
                   }
                 else
                   {
                     travel_type: travel_type,
                     message: 'Fail',
                     error: travel_type.errors.full_messages,
                     status: 406
                   }
                 end
  end

  def destroy
    travel_type = TravelType.where(travel_type_params)
    render json: if travel_type
                   if travel_type.delete
                     {
                       message: 'Success',
                       status: 200
                     }
                   else
                     {
                       message: 'Fail',
                       error: travel_type.errors.full_messages,
                       status: 406
                     }
                   end
                 else
                   {
                     message: 'Not found',
                     status: 404
                   }
                 end
  end

  def travel_type_params
    params.permit(:travel_id, :type_id)
  end
end
