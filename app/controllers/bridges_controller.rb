class BridgesController < ApplicationController
  respond_to :json

  def index
    render :json => Bridge.all
  end

  def discover
    begin
      render :json => [*Ruhue.discover]
    rescue Ruhue::TimeoutError => timeout
      Rails.logger.warn(timeout.message)  # Just return an empty array, the user's going to be asked to retry anyhow
      render :json => []
    end
  end

end
