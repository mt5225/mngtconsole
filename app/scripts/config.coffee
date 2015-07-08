#Setting up route
meanApp = angular.module('meanApp')
meanApp.config ['$routeProvider',
  ($routeProvider) ->
        $routeProvider
          .when '/users',
            templateUrl: 'views/users.html'
            controller: 'UserController'
          .when '/users/:openid',
            templateUrl: 'views/usereditor.html'
            controller: 'UserController'
          .when '/',
            templateUrl: 'views/main.html'
            controller: 'MainController'
          .when '/houses',
            templateUrl: 'views/houses.html'
            controller: 'HouseController'
          .when '/orders',
            templateUrl: 'views/orders.html'
            controller: 'OrderController'
          .when '/orders/:orderId',
            templateUrl: 'views/ordereditor.html'
            controller: 'OrderController'
          .when '/cal',
            templateUrl: 'views/cal.html'
            controller: 'CalController'
          .when '/surveys',
            templateUrl: 'views/surveys.html'
            controller: 'SurveyController'
          .when '/dashboard',
            templateUrl: 'views/dashboard.html'
            controller: 'DashboardController'
          .when '/500',
            templateUrl: 'views/500.html'
          .when '/404',
            templateUrl: 'views/404.html'
          .otherwise
            redirectTo: '/404'
]