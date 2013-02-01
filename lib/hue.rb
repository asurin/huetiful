class Hue

  def self.discover
    [*Ruhue.discover].map {|h| h.host}
  end

  def initialize(host, username)
    @client = Ruhue::Client.new(Ruhue.new(host), username)
  end

  def registered?
    @client.registered?
  end

  def register(device_name)
    @client.register(device_name) unless registered?
  end

  def lights
    @client.get('lights').data
  end

  def light(light_number)
    @client.get("lights/#{light_number}").data
  end

  def light=(light)
    response = @client.put("lights/#{light.number}/state", light.to_hue)
    puts response
  end

end