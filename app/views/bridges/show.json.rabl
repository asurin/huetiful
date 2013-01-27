object false
node :host do
  @bridge.host
end
node :name do
  @bridge.name
end
node :username do
  @bridge.username
end
node :registered do
  @bridge.registered
end
node :created_at do
  @bridge.created_at
end
node :created_at do
  @bridge.created_at
end
node :updated_at do
  @bridge.updated_at
end
node :lights do
  @bridge.all_lights.map { |light| partial("lights/light", :object => light) }
end