class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :travel


  def head 
    return "\
User,\
Item,\
Rating,\
partner:1,\
partner:2,\
partner:3,\
partner:4,\
partner:5,\
partner:6,\
time:1,\
time:2,\
time:3,\
time:4,\
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
U Rừng\n"
  end

  def beauty
    partner = [0, 0, 0, 0, 0, 0,]
    partner[self.partner - 1] = 1

    time = [0, 0, 0, 0,]
    time[self.time - 1] = 1

    type_users = FavoriteType.where("user_id": self.user_id).select(:type_id).map(&:type_id)
    # if type_users.length > 0
      type_user_kinds = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,]
      type_users.each do |type_id|
        type_user_kinds[type_id - 1] = 1
      end
    # else
    #   type_user_kinds = ['NA', 'NA', 'NA', 'NA', 'NA', 'NA', 'NA', 'NA', 'NA', 'NA', 'NA', 'NA', 'NA', 'NA',]
    # end

    return "\
#{check(self.user_id)},\
#{check(self.travel_id)},\
#{check(self.rating)},\
#{partner[0]},\
#{partner[1]},\
#{partner[2]},\
#{partner[3]},\
#{partner[4]},\
#{partner[5]},\
#{time[0]},\
#{time[1]},\
#{time[2]},\
#{time[3]},\
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
#{type_user_kinds[13]}\n"
  end

  def check(str)
    str || 'NA'
  end
end
