require 'color'
class Light < ActiveRecord::Base

  # Using https://github.com/AaronH/RubyHue/blob/master/bulb.rb for ct_to_rgb!

  has_and_belongs_to_many       :groups

  attr_accessible :on, :name, :brightness, :hue, :saturation, :x, :y, :ct, :alert, :effect, :color_mode, :reachable, :rgb

  def update_from_hue(bridge)
    updated_light = bridge.hue_controller.light(number)
    from_hue(number, updated_light)
  end

  def from_hue(number, light_data)
    state = light_data['state']
    self.name = light_data['name']
    self.on = state['on']
    self.brightness = state['bri']
    self.hue = state['hue']
    self.saturation = state['sat']
    self.x = state['xy'][0].to_f
    self.y = state['xy'][1].to_f
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
    matrix = [
     [3.2333, -1.5262, 0.2791],
     [-0.8268, 2.4667, 0.3323 ],
     [0.1294, 0.1983, 2.0280]
    ]
    if self.color_mode == 'xy'
      z = 1 - self.x - self.y
      r = (x * matrix[0][0]) + (y * matrix[0][1]) + (z * matrix[0][2])
      g = (x * matrix[1][0]) + (y * matrix[1][1]) + (z * matrix[1][2])
      b = (x * matrix[2][0]) + (y * matrix[2][1]) + (z * matrix[2][2])
      Color::RGB.from_fraction(r,g,b).html
    elsif self.color_mode == 'ct'
      # using method described at
      # http://www.tannerhelland.com/4435/convert-temperature-rgb-algorithm-code/
      temp = (1000000 / self.ct) / 100
      red = temp <= 66 ? 255 : 329.698727446 * ((temp - 60) ** -0.1332047592)
      green = if temp <= 66
                99.4708025861 * Math.log(temp) - 161.1195681661
              else
                288.1221695283 * ((temp - 60) ** -0.0755148492)
              end
      blue = if temp >= 66
               255
             elsif temp <= 19
               0
             else
               138.5177312231 * Math.log(temp - 10) - 305.0447927307
             end
      Color::RGB.new([[red,0].max, 255].min.to_i, [[green, 0].max, 255].min.to_i, [[blue, 0].max, 255].min.to_i).html
    else
      Color::HSL.new(self.hue.to_f / 182.04, self.saturation.to_f / 255.0 * 100.0, self.brightness.to_f / 255.0 * 100.0).to_rgb.html
    end
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
