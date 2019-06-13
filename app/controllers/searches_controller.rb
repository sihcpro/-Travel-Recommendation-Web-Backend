class SearchesController < ApplicationController
  # def show
  #   # Travel.joins(:start => :city).select("travels.id as travel_id").first.travel_id
  #   @destinations_name = Destination.joins(:city
  #     ).select("travel_id",
  #              "cities.name as destination_name").order("travel_id")
  #   @destinations = {}
  #   @destinations_name.each do |item|
  #     if @destinations[item.travel_id]
  #       @destinations[item.travel_id] = @destinations[item.travel_id] + [item.destination_name]
  #     else
  #       @destinations[item.travel_id] = [item.destination_name]
  #     end
  #   end

  #   @travels = Travel.all
  #   travels = []
  #   @travels.each do |item|
  #     travel = item.attributes
  #     travel['destinations'] = @destinations[item.id]
  #     travels += [travel]
  #   end

  #   render json:  if params[:page]
  #                   page = params[:page].to_i
  #                   {
  #                     travels: travels[(page * 10)..((page + 1) * 10 - 1)],
  #                     status: 201
  #                   }
  #                 else
  #                   {
  #                     travels: travels,
  #                     status: 201
  #                   }
  #                 end
  # end

  def show
    travel_ids = Travel.joins(:travel_types).where("rating >= #{params[:rating]} AND
      lower_price >= #{params[:lower_price]} AND
      upper_price <= #{params[:upper_price]}")
                    .where("travel_types.type_id in (#{params[:type]})")
                    .select(:id).distinct.map(&:id)
    if params[:user_id]
      user_id = params[:user_id]
    else
      user_id = -1
    end
    partner = params[:partner].split(',')
    time = params[:time].split(',')
    File.open("CARSKit.Workspace/user#{user_id}_travel.txt", 'w') do |f|
      travel_ids.each { |i| f.write("#{i}\n")}
    end
    head = []
    File.open("CARSKit.Workspace/train.csv", 'r') do |f|
      head = f.readline()[0..-2].split(', ')
      # puts head.to_s
    end
    File.open("CARSKit.Workspace/user#{user_id}_context.txt", 'w') do |f|
      time.each do |t|
        partner.each do |p|
          situation = "partner:#{p},time:#{t}  -> #{head.index("partner:#{p}")},#{head.index("time:#{t}")}"
          print situation + "  ->  "
          context = "#{head.index("partner:#{p}")-3},#{head.index("time:#{t}")-3}"
          puts context
          f.write("#{context}\n")
        end
      end
      puts 'done'
    end
    system("java -jar Recommender.jar -c setting.conf -u #{user_id}")
    travels = []
    File.open("CARSKit.Workspace/user#{user_id}_suggestion.txt", 'r') do |f|
      travel_all = f.read().split("\n")
      travel_all.each do |travel|
        travel = travel.split(',')
        travels = travels + [[travel[0].to_i, travel[1].to_f  ]]
      end
    end
    travels = travels.sort_by{ |a| [ a[1] ] }.reverse
    puts travels.to_s
    render json: {
      suggestions: travels.map{ |i| i[0] }
    }
  end

  def search_params
    params.permit(:rating, :lower_price, :upper_price, :type)
  end
end
