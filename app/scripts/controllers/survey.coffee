meanApp.controller 'SurveyController', ($scope, Global, SurveyService, $log, $routeParams, $location) ->
  if Global.authenticated isnt true
    $location.path "login" 
    return
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
      $scope.surveys.sort (a, b) ->
        switch a.createDay > b.createDay
          when true then -1
          when false then 1
      $scope.length = $scope.surveys.length
    )
  $scope.export = (surveyType) ->
    $log.debug "export data"
    data = []
    for item in $scope.surveys
      if item.type is surveyType
        answer = {}
        for k,v of item         
          if k.indexOf('question') > -1
            item[k] = JSON.stringify(v) if typeof v is 'object'
            $log.debug item[k]
            answer[k] = item[k]
          if k is "userinfo"
            answer['微信号'] = item[k].nickname
            answer['省份'] = item[k].province
            answer['城市'] = item[k].city
            answer['国家'] = item[k].country          
        data.push answer
    $log.debug data
    alasql('SELECT * INTO XLSX("export.xlsx",{headers:true}) FROM ?',[data])
