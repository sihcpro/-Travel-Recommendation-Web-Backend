class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :travel


  def head 
    return "\
userId,\
itemId,\
rating,\
price:1,\
price:2,\
price:3,\
price:4,\
price:5,\
Tâm linh,\
Di tích,\
Tham quan,\
Thắng cảnh,\
Ẩm thực,\
Giải trí,\
Nghỉ dưỡng,\
Mạo hiểm,\
Hồ sông suối,\
Đô thị,\
Nông thôn,\
Đồi núi,\
Biển,\
Rừng\n"
  end

  def beauty
    tra = self.travel
    price_steps = [0, 0, 0, 0, 0,]
    (tra.lower_price..tra.upper_price).each do |step|
      price_steps[step - 1] = 1
    end
    # puts price_steps.to_s

    typ = Travel.joins(:travel_types).where("travels.id": self.travel_id).select("travel_types.id as type_id").map( &:type_id )
    type_kinds = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,]
    typ.each do |type_id|
      type_kinds[type_id - 1] = 1
    end
    # puts type_kinds.to_s

    return "\
#{check(self.user_id)},\
#{check(self.travel_id)},\
#{check(self.rating)},\
#{price_steps[0]},\
#{price_steps[1]},\
#{price_steps[2]},\
#{price_steps[3]},\
#{price_steps[4]},\
#{type_kinds[0]},\
#{type_kinds[1]},\
#{type_kinds[2]},\
#{type_kinds[3]},\
#{type_kinds[4]},\
#{type_kinds[5]},\
#{type_kinds[6]},\
#{type_kinds[7]},\
#{type_kinds[8]},\
#{type_kinds[9]},\
#{type_kinds[10]},\
#{type_kinds[11]},\
#{type_kinds[12]},\
#{type_kinds[13]},\n"
  end

  def check(str)
    str || 'NA'
  end
end
