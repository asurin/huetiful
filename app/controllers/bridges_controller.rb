class BridgesController < ApplicationController
  respond_to :json

  def index
    render :json => Bridge.all
  end

  def show
    render :json => Bridge.find(params[:id])
  end

  def discover
    begin
      hues = [*Ruhue.discover]
      bridges = Array.new
      hues.each do |hue|
        bridge = Bridge.find_by_host(hue.host)
        if bridge.nil? || !Ruhue::Client.new(hue, bridge.username).registered?
          bridges << hue
        else
          bridges << bridge
        end
      end
      render :json => bridges
    rescue Ruhue::TimeoutError => timeout
      Rails.logger.warn(timeout.message)  # Just return an empty array, the user's going to be asked to retry anyhow
      render :json => []
    end
  end

  def create
    begin
      # TODO: More detailed error handling, specifically the case where we can no longer find the hue passed up
      host = params[:host]
      name = params[:name]
      bridge = Bridge.find_by_host(host)
      hues = [*Ruhue.discover]
      hue = nil
      hues.each { |opt| hue = opt if opt.host == host }
      client = Ruhue::Client.new(hue, 'huetifulapp')
      unless client.registered?
        bridge.delete! unless bridge.nil?
        client.register(name)
        bridge = Bridge.new(:host => host, :username => client.username, :name => name, :registered => true)
        bridge.save!
      end
      if bridge.nil?
        bridge = Bridge.new(:host => host, :username => client.username, :name => name, :registered => true)
        bridge.save!
        group = bridge.groups.build
        group.name = "All Lights"
        group.save!
        lights = client.get('lights')
        lights.data.each do |key,light|
          detailed_light = client.get("lights/#{key}")
          model_light = group.lights.build
          model_light.from_response(detailed_light)
          model_light.save!
        end
      end
      render :json => bridge
    rescue Exception => e
      Rails.logger.error(e.message)
      Rails.logger.error(e.backtrace)
      render :json => {:error => e}
    rescue Ruhue::APIError => e
      render :json => {:error => e} # No need to log anything here - we know this was pretty much guaranteed to be because they didn't hit pair
    end
  end

end
