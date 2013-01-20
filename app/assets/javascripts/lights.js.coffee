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

  Light
]
root.angular = angular
