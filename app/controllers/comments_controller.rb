class CommentsController < ApplicationController
  @@lock = false
  @@id_comments = []
  @@mutex = Mutex.new

  def index
    @comment = Comment.all
  end

  def create
    @comment = Comment.new(comment_create_params)
    render json: if @comment.save
                   @comment.travel.update_rating
                   Thread.new { update_suggestion(@comment.id) }
                   {
                     message: 'Create success',
                     status: 201
                   }
                 else
                   {
                     message: 'Create failt',
                     error: @comment.errors.full_messages,
                     status: 500
                   }
                 end
  end

  def show
    @comment = current_comment
    render json: if @comment
                   {
                     comment: @comment,
                     message: 'Success',
                     status: 200
                   }
                 else
                   {
                     comment: @comment,
                     message: 'Comment not found',
                     status: 404
                   }
                 end
  end

  def update
    @comment = current_comment
    render json: if @comment
                   if @comment.update(update_comment_params)
                     Thread.new { update_suggestion(@comment.id) }
                     {
                       comment: @comment,
                       message: 'Update comment success',
                       status: 200
                     }
                   else
                     {
                       comment: @comment,
                       message: 'Fail to update!',
                       error: @comment.errors.full_messages,
                       status: 500
                     }
                   end
                 else
                   {
                     message: 'Comment not found!',
                     status: 404
                   }
                 end
  end

  def comment_create_params
    params.permit(:user_id, :travel_id, :content, :rating, :time, :partner)
  end

  def current_comment
    Comment.find_by(id: params[:id]) if params[:id]
  end

  def update_comment_params
    params.permit(:rating, :content, :partner, :time)
  end

  def update_suggestion(id)
    puts "---------- #{id} #{@@lock}"
    # @@mutex.synchronize do​​
    @@id_comments += [id]
    return if @@lock
    @@lock = true

    puts "----------++++++++++ #{@@id_comments}"
    tmp_id_comments = @@id_comments
    @@id_comments = []
    update_csv(tmp_id_comments)
    # export_csv()
    puts '----------++++++++++>>>>>>>>>>> '
    system("java -jar BuildModel.jar -c setting.conf")
    puts '----------++++++++++>>>>>>>>>>><<<<<<<<<<'
    puts tmp_id_comments
    puts '----------++++++++++>>>>>>>>>>><<<<<<<<<<+++++++++++'
    tmp_id_comments.each do |id|
      user_id = Comment.find_by(id: id).user_id
      system("java -jar Recommender.jar -c setting.conf -u #{user_id}")
      puts "----------++++++++++>>>>>>>>>>><<<<<<<<<<+++++++++++ #{user_id}"
      travels = []
      File.open("CARSKit.Workspace/user#{user_id}_suggestion.txt", 'r') do |f|
        travel_all = f.read().split("\n")
        puts travel_all.to_s
        travel_all.each do |travel|
          travel = travel.split(',')
          travels = travels + [[travel[0].to_i, travel[1].to_f]]
        end
        travels = travels.sort_by{ |a| [ a[1] ] }.reverse
      end
      puts travels.to_s
      Suggestion.where(user_id: user_id).delete_all
      travels[0..9].each_with_index do |travel, idx|
        print '.' if Suggestion.create(user_id: user_id,
                                       travel_id: travel[0],
                                       rate: trave[1])
      end
    end
    @@lock = false
    # end​​
    puts '----------++++++++++>>>>>>>>>>><<<<<<<<<<+++++++++++-----------'
  end

  def update_csv(comments_id)
    File.open('result.csv', 'a') do |f|
      comments_id.each do |id|
        comment = Comment.find_by(id: id)
        f.write(comment.beauty())
      end
    end
  end

  def export_csv
    File.open('result.csv', 'w+') do |f|
      f.write(Comment.first.head)
      Comment.all.each do |comment|
        f.write(comment.beauty())
      end
    end
  end
end
