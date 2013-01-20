
root = global ? window

LightsIndexCtrl = ($scope, Light) ->
  $scope.lights = Light.query()
  $scope.destroy = ->
    dconfirm = confirm("Are you sure?")
    if dconfirm
      original = @light
      @light.destroy ->
        $scope.lights = _.without($scope.lights, original)

LightsIndexCtrl.$inject = ['$scope', 'Light'];

LightsCreateCtrl = ($scope, $location, Light) ->
  $scope.save = ->
    Light.save $scope.light, (light) ->
      $location.path "/lights/#{light.id}/edit"

LightsCreateCtrl.$inject = ['$scope', '$location', 'Light'];

LightsShowCtrl = ($scope, $location, $routeParams, Light) ->
  Light.get
    id: $routeParams.id
  , (light) ->
    self.original = light
    $scope.light = new Light(self.original)

LightsShowCtrl.$inject = ['$scope', '$location', '$routeParams', 'Light'];

LightsEditCtrl = ($scope, $location, $routeParams, Light) ->
  self = this
  Light.get
    id: $routeParams.id
  , (light) ->
    self.original = light
    $scope.light = new Light(self.original)

  $scope.isClean = ->
    angular.equals self.original, $scope.light

  $scope.destroy = ->
    dconfirm = confirm("Are you sure?")
    if dconfirm
      $scope.light.destroy ->
        $location.path "/lights"


  $scope.save = ->
    Light.update $scope.light, (light) ->
      $location.path "/lights"

LightsEditCtrl.$inject = ['$scope', '$location', '$routeParams', 'Light'];

# exports
root.LightsIndexCtrl  = LightsIndexCtrl
root.LightsCreateCtrl = LightsCreateCtrl
root.LightsShowCtrl   = LightsShowCtrl
root.LightsEditCtrl   = LightsEditCtrl 