class BackupsController < ApplicationController
  def create
    message = 'Export all comments to file: '

    filepath = File.join(Rails.root, 'db', 'backup_comments.json')
    # get a file ready, the 'data' directory has already been added in Rails.root
    message += filepath.to_s

    require 'json'
    comments = Comment.all.as_json
    File.open(filepath, 'w') do |f|
      puts comments
      f.write(JSON.pretty_generate(comments))
    end

    render json: {
      message: message
    }
  end

  def update
    filepath = File.join(Rails.root, 'db', 'backup_comments.json')

    if File.exist?(filepath)
      require 'json'
      comments = JSON.parse(File.read(filepath))

      comments.each do |comment|
        Comment.create(comment)
      end
      message = "Load finish comments at #{filepath}"
    else
      puts "Input file not found: #{filepath}"
      message = "Input file not found: #{filepath}"
    end
    render json: { message: message }
  end

  def destroy
    filepath = File.join(Rails.root, 'db', 'backup_comments.json')
    if File.exist?(filepath)
      File.open(filepath, 'w') do |f|
        f.write('')
      end
      message = "Destroy backup comments file at #{filepath}"
    else
      puts "Input file not found: #{filepath}"
      message = "Input file not found: #{filepath}"
    end

    render json: { message: message }
  end
end
