class LightsController < ApplicationController
  respond_to :json

  def show
    @light = Light.find(params[:id])
  end

  def update
    @light = Light.find(params[:id])
    assignable_params = params
    assignable_params.delete :id  # Definitely a better way to do this, but just want to test for know
    assignable_params.delete :action
    assignable_params.delete :controller
    assignable_params.delete :light
    assignable_params.delete :created_at
    assignable_params.delete :updated_at
    # We may need to merge.  Not sure what desired behavior is - full override, or override-changed?
    @light.update_attributes(assignable_params)
    bridge = @light.groups.first.bridge # Short-circuit this?
    hue = Hue.new(bridge.host, 'huetifulapp')
    hue.light = @light
  end

end
