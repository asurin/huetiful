
root = global ? window

BridgesIndexCtrl = ($scope, Bridge) ->
  $scope.bridges = Bridge.query()
  $scope.destroy = ->
    dconfirm = confirm("Are you sure?")
    if dconfirm
      original = @bridge
      @bridge.destroy ->
        $scope.bridges = _.without($scope.bridges, original)

BridgesIndexCtrl.$inject = ['$scope', 'Bridge'];

BridgesCreateCtrl = ($scope, $location, Bridge, Discover) ->
  $scope.availableBridges = null
  $scope.scan = ->
    Discover.query (data) ->
      $scope.availableBridges = data
  $scope.save = ->
    Bridge.save $scope.bridge, (bridge) ->
      $location.path "/bridges/#{bridge.id}/edit"
  $scope.scannedAndNotFound = ->
    $scope.availableBridges != null && $scope.availableBridges.length == 0 # Prevent flicker in due to uPnP being slow/multicast fail
  $scope.scan()

BridgesCreateCtrl.$inject = ['$scope', '$location', 'Bridge', 'Discover'];

BridgesShowCtrl = ($scope, $location, $routeParams, Bridge) ->
  Bridge.get
    id: $routeParams.id
  , (bridge) ->
    self.original = bridge
    $scope.bridge = new Bridge(self.original)

BridgesShowCtrl.$inject = ['$scope', '$location', '$routeParams', 'Bridge'];

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