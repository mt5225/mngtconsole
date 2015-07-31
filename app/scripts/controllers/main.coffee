meanApp.controller 'MainController', ($scope, Global, $location) ->
  if Global.authenticated isnt true
    $location.path "login" 
    return
  $scope.global = Global
