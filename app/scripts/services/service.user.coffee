meanApp = angular.module('meanApp')
meanApp.service 'UserService', ($resource) ->
    console.log "User Service"
    return $resource '/api/users/:openid', { openid: '@openid'}


