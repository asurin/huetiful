#!/usr/bin/env ruby
require "../config/environment"
require "../config/application.rb"

trap("INT") do
  puts "terminating monitor"
  exit
end

lights = Hash.new

Bridge.all.each do |bridge|
  bridge.all_lights.each do |light|
    lights[light] = bridge
  end
end

while true do
  sleep 0.1
  lights.each do |light, bridge|
    light.update_from_hue(bridge)
    light.save!
  end
end