meanApp.controller 'SurveyController', ($scope, Global, SurveyService, $log, $routeParams, $location) ->
  #survey questions
  VOL = 
    question1 : "您是否热爱生活，热爱自然？"
    question2 : "您是否同意以下观点：只要专注于一件事，必定会有收获？"
    question3 : "您更倾向于过程的体验让人愉悦，或是结果满意让人愉悦？"
    question4 : "都市繁华的喧闹和乡村生活的纯粹，您更喜欢哪种生活？"
    question5 : "您是否可以专注某件事至少3-5年？"
    question6 : "您觉得自己擅长什么？"
    question7 : "请您描述您向往的生活场景"
    question8 : "每个人心中都有或大或小的梦想，请您描述您的梦想"
    question9 : "您希望参与到我们当中的形式是"
    question10 : "如果你愿意加入我们，或者长期保持互动联系，请您留下姓名及联系方式"
  RES = 
    question1 : "通常说来，您会多久产生一次装点烦恼，远足寻找心灵净土的感觉?"
    question2 : "对于您来说，旅行的意义在于什么？"
    question4 : "从以下选项中选择您希望去的地方,再选择您是否会来部落"
    question5 : "如果希望营地给你足够多的感动，您还希望这里有些什么项目？"
    question6 : "您是否接受营地里可能会有小动物、小昆虫的骚扰？"
    question7 : "在我们的营地，您可以临江高歌，自有群山回应；品尝天然馈赠的鲜笋，鲜嫩无比的江鱼（很可能是你自己钓的）；一草一木、一椽一柱，皆生于自然，纯手工制作；您会喜欢这里吗？"
    question8 : "你愿意分享一下你的人生最大的愿望？"
    question9 : "如果您是营地的主人，您会希望怎样的朋友前来？"

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

  $scope.findOne = () ->
    $log.debug "survey id = #{$routeParams._id}"
    SurveyService.get {surveyId: $routeParams._id}
    .$promise.then ((payload) ->
      $scope.survey = payload
      questionSet = {}
      switch $scope.survey.type
        when "入住" then questionSet = RES       
        when "志愿者" then questionSet = VOL
      
      surveyResult = []
      for k,v of questionSet
        item = {}
        item.questionIndex = k
        item.question = v
        if payload[k]?
          item.answer = payload[k]
        else
          item.answer = "未回答"
        surveyResult.push item
      $scope.surveyResult = surveyResult
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


