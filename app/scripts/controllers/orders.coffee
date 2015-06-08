meanApp.controller 'OrderController', ['$scope', 'Global', 'OrderService', ($scope, Global, OrderService) ->

  $scope.global = Global
  $scope.find = () ->
    $scope.orders = OrderService.query()
]