class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :travel


  def head 
    return "\
User,\
Item,\
Rating,\
partner,\
time\n"
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
#{self.partner},\
#{self.time }\n"
  end

  def check(str)
    str || 'NA'
  end
end
