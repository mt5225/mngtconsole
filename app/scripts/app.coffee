'use strict'

meanApp = angular.module 'meanApp', ['ngCookies', 'ngResource', 'ngRoute', 'smart-table']
meanApp.constant('_', window._)
meanApp.constant('API_ENDPOINT', 'http://qa.aghchina.com.cn:3000')
meanApp.constant('APP_URL', 'http://qa.aghchina.com.cn:9000')
meanApp.constant('OPENID', 'o82BBs9o0ndCJPt0bDxrzhpettpE') 
# meanApp.constant('API_ENDPOINT', 'http://app.aghchina.com.cn:3000')
# meanApp.constant('APP_URL', 'http://app.aghchina.com.cn:9000')
# meanApp.constant('OPENID', 'osIpsuHE6jlAKu-jduZw3AYkQfu8') 

#note: use OPENID as index for login credention

#logout idle users
meanApp.run ($rootScope, $location, $log) ->
  lastDigestRun = new Date
  $rootScope.$watch ->
    now = new Date   
    sec = (now - lastDigestRun) / 1000
    $log.debug sec
    if sec > 900
      $location.path "/login"
    else
    lastDigestRun = now
    return
  return

meanApp.filter 'timeToStr', (dateService)->
  (input) ->
    dateService.formatDate(new Date (parseInt(input)*1000))