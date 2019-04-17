class HistoryController < ApplicationController
  def show
    all_history = History.all
    return json: {
      all_history
    }
  end
end
