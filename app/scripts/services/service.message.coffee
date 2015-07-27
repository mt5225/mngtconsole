meanApp = angular.module('meanApp')
meanApp.service 'MessageService', ($http, $log, API_ENDPOINT) ->
  console.log "Message Service"
  return {
    send: (body) ->
      $http(
          method: 'POST'
          url: "#{API_ENDPOINT}/api/sendmsg"
          headers: {'Content-Type': 'application/json'}
          data: JSON.stringify(body)
          dataType: 'json'
        ).success((data) ->
          $log.info "[message service] wechat message success"
        ).error (data) ->
          $log.error "[message service] failed to send wechat message"
          $log.debug data
  }