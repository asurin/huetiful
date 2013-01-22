class Light < ActiveRecord::Base

  has_and_belongs_to_many       :groups

  def from_response(response)
    light_data = response.data
    state = light_data['state']
    self.name = light_data['name']
    self.on = state['on']
    self.brightness = state['bri']
    self.hue = state['hue']
    self.saturation = state['sat']
    self.x = state['xy'][0].to_f
    self.y = state['xy'][0].to_f
    self.ct = state['ct'].to_f
    self.alert = state['alert']
    self.effect = state['effect']
    self.color_mode = state['colormode']
    self.reachable = state['reachable']
    self
  end

end
