meanApp.controller 'SurveyController', ($scope, Global, SurveyService, $log, $routeParams) ->
  $scope.global = Global
  $scope.find = () ->
    SurveyService.query()
    .$promise.then ((payload) ->
      openid = $routeParams['openid']
      if openid?
        record = []
        for item in payload
          record.push item if item.userinfo.openid is openid
        $scope.surveys = record
      else
        $scope.surveys = payload
      $scope.length = $scope.surveys.length
    )
  $scope.export = () ->
    $log.debug "export data"
    data = $scope.surveys
    for item in data
      for k,v of item
        item[k] = JSON.stringify(v) if typeof v is 'object'
    alasql('SELECT * INTO XLSX("export.xlsx",{headers:true}) FROM ?',[data])
