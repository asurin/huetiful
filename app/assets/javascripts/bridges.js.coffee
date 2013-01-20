root = global ? window

angular.module("bridges", ["ngResource"]).factory "Bridge", ['$resource', ($resource) ->
  Bridge = $resource("/bridges/:id",
    id: "@id"
  ,
    update:
      method: "PUT"

    destroy:
      method: "DELETE"
  )
  Bridge::destroy = (cb) ->
    Bridge.remove
      id: @id
    , cb

  Bridge
]
root.angular = angular
