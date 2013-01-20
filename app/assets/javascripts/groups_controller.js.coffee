
root = global ? window

GroupsIndexCtrl = ($scope, Group) ->
  $scope.groups = Group.query()
  $scope.destroy = ->
    dconfirm = confirm("Are you sure?")
    if dconfirm
      original = @group
      @group.destroy ->
        $scope.groups = _.without($scope.groups, original)

GroupsIndexCtrl.$inject = ['$scope', 'Group'];

GroupsCreateCtrl = ($scope, $location, Group) ->
  $scope.save = ->
    Group.save $scope.group, (group) ->
      $location.path "/groups/#{group.id}/edit"

GroupsCreateCtrl.$inject = ['$scope', '$location', 'Group'];

GroupsShowCtrl = ($scope, $location, $routeParams, Group) ->
  Group.get
    id: $routeParams.id
  , (group) ->
    self.original = group
    $scope.group = new Group(self.original)

GroupsShowCtrl.$inject = ['$scope', '$location', '$routeParams', 'Group'];

GroupsEditCtrl = ($scope, $location, $routeParams, Group) ->
  self = this
  Group.get
    id: $routeParams.id
  , (group) ->
    self.original = group
    $scope.group = new Group(self.original)

  $scope.isClean = ->
    angular.equals self.original, $scope.group

  $scope.destroy = ->
    dconfirm = confirm("Are you sure?")
    if dconfirm
      $scope.group.destroy ->
        $location.path "/groups"


  $scope.save = ->
    Group.update $scope.group, (group) ->
      $location.path "/groups"

GroupsEditCtrl.$inject = ['$scope', '$location', '$routeParams', 'Group'];

# exports
root.GroupsIndexCtrl  = GroupsIndexCtrl
root.GroupsCreateCtrl = GroupsCreateCtrl
root.GroupsShowCtrl   = GroupsShowCtrl
root.GroupsEditCtrl   = GroupsEditCtrl 