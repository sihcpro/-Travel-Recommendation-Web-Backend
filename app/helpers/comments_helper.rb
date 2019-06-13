module CommentsHelper
  def get_all_suggestions
    all_suggestions = {}
    (1..5).each do |i|
      line_number = 0
      File.readlines("./CARSKit.Workspace/CAMF_CI-top-10-items fold [#{i}].txt").each do |line|
        line_number += 1
        next if line_number == 1
        user_id = line.match(/[\d]+/).to_s.to_i

        suggestions = line.scan(/\([^\(]+\)/)
        suggestions.each do |item|
          travel_id = item.match(/[\d]+,/).to_s.chomp(":").to_i
          rate = item.match(/[\d]+.[\d]+\)/).to_s.chomp(":").to_f

          if all_suggestions[user_id] == nil
            all_suggestions[user_id] = [[travel_id, rate]]
          else
            all_suggestions[user_id] += [[travel_id, rate]]
          end
        end
      end
    end
    all_suggestions
  end
end
