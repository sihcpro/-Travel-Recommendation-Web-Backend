class BackupController < ApplicationController
  def create
    message = "Export all comments to file: "

    filepath = File.join(Rails.root, 'db', 'backup_comments.json')
    # get a file ready, the 'data' directory has already been added in Rails.root
    message = message + "#{filepath}"

    require 'json'
    comments = Comment.all.as_json
    File.open(filepath, 'w') do |f|
      f.write(JSON.pretty_generate(comments))
    end

    render json: {
      message: message
    }
  end

  def update
    filepath = File.join(Rails.root, 'db', 'backup_comments.json')

    unless File.exist?(filepath)
      puts "Input file not found: #{filepath}" 
      message = "Input file not found: #{filepath}"
    else
      require 'json'
      comments = JSON.parse(File.read(filepath))

      comments.each do |comment|
        Comment.create(comment)
      end
      message = "Load finish comments at #{filepath}"
    end
    render json: { message: message }
  end

  def destroy
    filepath = File.join(Rails.root, 'db', 'backup_comments.json')
    unless File.exist?(filepath)
      puts "Input file not found: #{filepath}" 
      message = "Input file not found: #{filepath}"
    else
      File.open(filepath, 'w') do |f|
        f.write("")
      end
      message = "Destroy backup comments file at #{filepath}"
    end

    render json: { message: message}
  end
end
