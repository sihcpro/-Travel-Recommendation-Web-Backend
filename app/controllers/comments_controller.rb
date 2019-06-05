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
    system("java -jar CARSKit-v0.3.5.jar -c setting.conf")
    puts '----------++++++++++>>>>>>>>>>><<<<<<<<<<'
    puts @@id_comments
    all_suggestions = get_all_suggestions()
    puts tmp_id_comments
    puts '----------++++++++++>>>>>>>>>>><<<<<<<<<<+++++++++++'
    tmp_id_comments.each do |user_id|
      puts "----------++++++++++>>>>>>>>>>><<<<<<<<<<+++++++++++ #{user_id}"

      if all_suggestions[user_id] != nil
        Suggestion.where(user_id: user_id).delete_all
        all_suggestions[user_id][0..18].each do |suggestion|
          Suggestion.create(user_id: user_id, travel_id: suggestion[0], rate: suggestion[1])
        end
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
