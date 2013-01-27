class BridgesController < ApplicationController
  respond_to :json

  def index
    render :json => Bridge.all
  end

  def show
    @bridge = Bridge.find(params[:id])
  end

  def discover
    begin
      hues = Hue.discover
      bridges = Array.new
      hues.each do |hue_host|
        bridge = Bridge.find_by_host(hue_host)
        if bridge.nil? || !Hue.new(hue_host, bridge.username).registered?
          bridges << {:host => hue_host}
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
      host = params[:host]
      name = params[:name]
      bridge = Bridge.find_by_host(host)
      hue = Hue.new(host, 'huetifulapp')
      unless hue.registered?
        bridge.delete! unless bridge.nil?
        hue.register(name)
        bridge = Bridge.new(:host => host, :username => 'huetifulapp', :name => name, :registered => true)
        bridge.save!
      end
      if bridge.nil?
        bridge = Bridge.new(:host => host, :username => 'huetifulapp', :name => name, :registered => true)
        bridge.save!
        group = bridge.groups.build(:name => "All Lights", :all_group => true)
        group.save!
        hue.lights.each do |key,light|
          detailed_light = hue.light(key)
          model_light = group.lights.build
          model_light.from_hue(key, detailed_light)
          model_light.save!
          group.lights << model_light
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
