meanApp.controller 'AvailableController', ($scope, Global, AvailableService, HouseService, $log, $q, dateService) ->
  $scope.global = Global
  $scope.showResult = false

  $scope.searchAvailableHouse = () ->
    #list all Houses
    HouseService.query()
    .$promise.then ((payload) ->  
      promises = _.map payload, (house) ->
        $log.debug house  
        order = {}
        order.checkInDay = dateService.formatDate $scope.checkInDay
        order.checkOutDay = dateService.formatDate $scope.checkOutDay
        order.houseId = house.id
        order.display_id = house.display_id
        order.name = house.name
        AvailableService.checkAvailable order
      $q.all(promises)
      .then (results) ->
        $log.debug results
        aArray = []
        for item in results
          t = {}
          switch item.data.available
            when 'true' then t.status = "空闲"
            when 'false' then t.status = "已订满"
            when 'N/A' then t.status = "不可预订"
          t.houseInfo = JSON.parse item.config.data
          aArray.push t
        $scope.availableArray = aArray
        $scope.showResult = true
    )
