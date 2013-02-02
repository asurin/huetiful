#!/usr/bin/env ruby
require "./config/environment"
require "./config/application.rb"
require 'net/http'

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
  sleep 5
  lights.each do |light, bridge|
    light.update_from_hue(bridge)
    light.save!
    test_hash = {'test' => true}
    data_hash = {
        'channel' => '/lights',
        'data' => light.to_json
    }
    #Net::HTTP.post_form(URI.parse("http://localhost:9292/faye"), :message => {:channel => 'lights', :data => light}.to_json)
    command = "curl http://localhost:9292/faye -d 'message=#{data_hash.to_json}'"
    puts command
    `#{command}`
  end
end