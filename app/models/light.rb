require 'color'
class Light < ActiveRecord::Base

  has_and_belongs_to_many       :groups

  attr_accessible :on, :name, :brightness, :hue, :saturation, :x, :y, :ct, :alert, :effect, :color_mode, :reachable, :rgb

  def from_hue(number, light_data)
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
    self.number = number
    self
  end

  def to_hue
    # Stick with HSB colors for now
    {
        'on' => self.on,
        'bri' => self.brightness,
        'hue' => self.hue,
        'sat' => self.saturation,
        'alert' => self.alert
    }
  end

  def rgb
    Color::HSL.new(self.hue.to_f / 182.04, self.saturation.to_f / 255.0 * 100.0, self.brightness.to_f / 255.0 * 100.0).to_rgb.html
  end

  def rgb=(hex)
    color = Color::RGB.from_html(hex)
    # Manual calculation is necessary here because of an error in the Color library
    r = color.r
    g = color.g
    b = color.b
    max = [r, g, b].max
    min = [r, g, b].min
    delta = max - min
    v = max * 100
    if max != 0.0
      s = delta / max *100
    else
      s = 0.0
    end
    if s == 0.0
      h = 0.0
    else
      if r == max
        h = (g - b) / delta
      elsif g == max
        h = 2 + (b - r) / delta
      elsif b == max
        h = 4 + (r - g) / delta
      end
      h *= 60.0
      if h < 0
        h += 360.0
      end
    end
    self.hue = (h * 182.04).round
    self.saturation = (s / 100.0 * 255.0).round
    self.brightness = (v / 100.0 * 255.0).round
  end

end
