class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :travel


  def head 
    return "\
User,\
Item,\
Rating,\
U Tâm linh,\
U Di tích,\
U Tham quan,\
U Thắng cảnh,\
U Ẩm thực,\
U Giải trí,\
U Nghỉ dưỡng,\
U Mạo hiểm,\
U Hồ sông suối,\
U Đô thị,\
U Nông thôn,\
U Đồi núi,\
U Biển,\
U Rừng,\
T Tâm linh,\
T Di tích,\
T Tham quan,\
T Thắng cảnh,\
T Ẩm thực,\
T Giải trí,\
T Nghỉ dưỡng,\
T Mạo hiểm,\
T Hồ sông suối,\
T Đô thị,\
T Nông thôn,\
T Đồi núi,\
T Biển,\
T Rừng,\
price:1,\
price:2,\
price:3,\
price:4,\
price:5\n"
  end

  def beauty
    tra = self.travel
    price_steps = [0, 0, 0, 0, 0,]
    (tra.lower_price..tra.upper_price).each do |step|
      price_steps[step - 1] = 1
    end
    # puts price_steps.to_s

    type_users = FavoriteType.where("user_id": self.user_id).select(:type_id).map(&:type_id)
    # if type_users.length > 0
      type_user_kinds = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,]
      type_users.each do |type_id|
        type_user_kinds[type_id - 1] = 1
      end
    # else
    #   type_user_kinds = ['NA', 'NA', 'NA', 'NA', 'NA', 'NA', 'NA', 'NA', 'NA', 'NA', 'NA', 'NA', 'NA', 'NA',]
    # end

    type_travels = TravelType.where("travel_id": self.travel_id).select("type_id").map(&:type_id)
    type_travel_kinds = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,]
    type_travels.each do |type_id|
      type_travel_kinds[type_id - 1] = 1
    end
    # puts type_travel_kinds.to_s

    return "\
#{check(self.user_id)},\
#{check(self.travel_id)},\
#{check(self.rating)},\
#{type_user_kinds[0]},\
#{type_user_kinds[1]},\
#{type_user_kinds[2]},\
#{type_user_kinds[3]},\
#{type_user_kinds[4]},\
#{type_user_kinds[5]},\
#{type_user_kinds[6]},\
#{type_user_kinds[7]},\
#{type_user_kinds[8]},\
#{type_user_kinds[9]},\
#{type_user_kinds[10]},\
#{type_user_kinds[11]},\
#{type_user_kinds[12]},\
#{type_user_kinds[13]},\
#{type_travel_kinds[0]},\
#{type_travel_kinds[1]},\
#{type_travel_kinds[2]},\
#{type_travel_kinds[3]},\
#{type_travel_kinds[4]},\
#{type_travel_kinds[5]},\
#{type_travel_kinds[6]},\
#{type_travel_kinds[7]},\
#{type_travel_kinds[8]},\
#{type_travel_kinds[9]},\
#{type_travel_kinds[10]},\
#{type_travel_kinds[11]},\
#{type_travel_kinds[12]},\
#{type_travel_kinds[13]},\
#{price_steps[0]},\
#{price_steps[1]},\
#{price_steps[2]},\
#{price_steps[3]},\
#{price_steps[4]}\n"
  end

  def check(str)
    str || 'NA'
  end
end
