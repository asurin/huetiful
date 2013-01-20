root = global ? window

angular.module("groups", ["ngResource"]).factory "Group", ['$resource', ($resource) ->
  Group = $resource("/groups/:id",
    id: "@id"
  ,
    update:
      method: "PUT"

    destroy:
      method: "DELETE"
  )
  Group::destroy = (cb) ->
    Group.remove
      id: @id
    , cb

  Group
]
root.angular = angular
