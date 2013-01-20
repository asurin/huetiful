root = global ? window

angular.module("discover", ["ngResource"]).factory "Discover", ['$resource', ($resource) ->
  Discover = $resource("/bridges/discover")

  Discover
]
root.angular = angular
