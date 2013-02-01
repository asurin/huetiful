
root = global ? window

BridgesIndexCtrl = ($scope, $location, Bridge) ->
  $scope.bridges = null
  Bridge.query (data) ->
    if data.length == 1
      $location.path "/bridges/#{data[0].id}"
    else
      $scope.bridges = data

  $scope.destroy = ->
    dconfirm = confirm("Are you sure?")
    if dconfirm
      original = @bridge
      @bridge.destroy ->
        $scope.bridges = _.without($scope.bridges, original)
  $scope.showHero = ->
    $scope.bridges != null && $scope.bridges.length == 0

BridgesIndexCtrl.$inject = ['$scope', '$location', 'Bridge'];

BridgesCreateCtrl = ($scope, $location, Bridge, Discover) ->
  $scope.availableBridges = null
  $scope.scan = ->
    Discover.query (data) ->
      $scope.availableBridges = data
  $scope.save = ($index) ->
    $scope.retryIndex = null
    Bridge.save $scope.availableBridges[$index], (bridge) ->
      $location.path "/bridges"
      if bridge.error?
        $scope.retryIndex = $index
      else
        console.log(bridge)
  $scope.scannedAndNotFound = ->
    $scope.availableBridges != null && $scope.availableBridges.length == 0 # Prevent flicker in due to uPnP being slow/multicast fail
  $scope.scan()

BridgesCreateCtrl.$inject = ['$scope', '$location', 'Bridge', 'Discover'];

BridgesShowCtrl = ($scope, $location, $routeParams, Bridge, Light) ->
  Bridge.get
    id: $routeParams.id, (bridge) ->
      self.original = bridge
      $scope.bridge = new Bridge(self.original)
  $scope.lightOff = (lightIndex) ->
    lightToUpdate = $scope.bridge.lights[lightIndex]
    lightToUpdate.on = false
    $scope.updateLight(lightToUpdate)
  $scope.lightOn = (lightIndex) ->
    lightToUpdate = $scope.bridge.lights[lightIndex]
    lightToUpdate.on = true
    $scope.updateLight(lightToUpdate)
  $scope.switchColor = (index, color) ->
    light = $scope.bridge.lights[index]
    light.rgb = color
    $scope.updateLight(light)
  $scope.updateLight = (light) ->
    self.original = light
    wrappedLight = new Light(self.original)
    wrappedLight.$update
      id: light.id

BridgesShowCtrl.$inject = ['$scope', '$location', '$routeParams', 'Bridge', 'Light'];

BridgesEditCtrl = ($scope, $location, $routeParams, Bridge) ->
  self = this
  Bridge.get
    id: $routeParams.id
  , (bridge) ->
    self.original = bridge
    $scope.bridge = new Bridge(self.original)

  $scope.isClean = ->
    angular.equals self.original, $scope.bridge

  $scope.destroy = ->
    dconfirm = confirm("Are you sure?")
    if dconfirm
      $scope.bridge.destroy ->
        $location.path "/bridges"

  $scope.save = ->
    Bridge.update $scope.bridge, (bridge) ->
      $location.path "/bridges"

BridgesEditCtrl.$inject = ['$scope', '$location', '$routeParams', 'Bridge'];

# exports
root.BridgesIndexCtrl  = BridgesIndexCtrl
root.BridgesCreateCtrl = BridgesCreateCtrl
root.BridgesShowCtrl   = BridgesShowCtrl
root.BridgesEditCtrl   = BridgesEditCtrl 