meanApp.controller 'SurveyController', ['$scope', 'Global', 'SurveyService', ($scope, Global, SurveyService) ->
  $scope.global = Global
  $scope.find = () ->
    $scope.surveys = SurveyService.query()
]