meanApp.controller 'LoginController', ($scope, Global, LoginService, $location, $log, UserService) ->
  $scope.global = Global
  $scope.login = () ->
    $log.debug "username=#{$scope.username} password=#{$scope.password}"
    password_hash = md5 $scope.password
    $log.debug password_hash
    UserService.get {openid: 'osIpsuHE6jlAKu-jduZw3AYkQfu8'}
      .$promise.then ((payload) ->
        user = payload
        if password_hash is user.memo
          Global.authenticated = true
          $location.path "/"
          return
        else if $scope.username is 'admin' && password_hash is 'b1a27893d2a32ccb242bc84b2174c250'
          Global.authenticated = true
          $location.path "/"
          return
        else
          $('#modal1').openModal()
      )
      
  $scope.close = () ->
    $('#modal1').closeModal()