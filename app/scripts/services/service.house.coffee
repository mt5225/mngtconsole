meanApp = angular.module('meanApp')
meanApp.service 'HouseService', ($resource) ->
    console.log "House Service"
    return $resource '/api/houses/:houseId', { houseId: '@id'}


