class Bridge < ActiveRecord::Base
  has_many          :groups

  attr_accessible   :username, :name, :host, :registered

  def all_lights
    self.groups.first.lights
  end

  def hue_controller
    Hue.new(host, 'huetifulapp')
  end
end
