root = global ? window

angular.module("lights", ["ngResource"]).factory "Light", ['$resource', ($resource) ->
  Light = $resource("/lights/:id",
    id: "@id"
  ,
    update:
      method: "PUT"

    destroy:
      method: "DELETE"
  )
  Light::destroy = (cb) ->
    Light.remove
      id: @id
    , cb

  Light::updateFromJSON = (jsonObject) ->
    @alert = jsonObject.alert if jsonObject.alert?
    @brightness = jsonObject.brightness if jsonObject.brightness?
    @color_mode = jsonObject.color_mode if jsonObject.color_mode?
    @created_at = jsonObject.created_at if jsonObject.created_at?
    @ct = jsonObject.ct if jsonObject.ct?
    @effect = jsonObject.effect if jsonObject.effect?
    @hue = jsonObject.hue if jsonObject.hue?
    @name = jsonObject.name if jsonObject.name?
    @on = jsonObject.on if jsonObject.on?
    @reachable = jsonObject.reachable if jsonObject.reachable?
    @saturation = jsonObject.saturation if jsonObject.saturation?
    @updated_at = jsonObject.updated_at if jsonObject.updated_at?
    @x = jsonObject.x if jsonObject.x?
    @y = jsonObject.y if jsonObject.y?
    @rgb = jsonObject.rgb if jsonObject.rgb?

  Light
]
root.angular = angular
