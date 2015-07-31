#Global service for global variables
meanApp = angular.module('meanApp')
meanApp.factory 'Global', [
  () ->
    _this = this
    _this._data =
      user: window.user
      authenticated: !! window.user
    return _this._data
]

#Passing data between pages
meanApp.factory 'paramService', ->
  saveData = {}
  return {
    set: (data) ->
      saveData = data
    get: ->
      saveData
  }


meanApp.factory 'uuidService', ->
  return {
    generateUUID: ->
      delim = ""
      S4 = ->
        (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1)
      (S4() + delim + S4())
  }

meanApp.factory 'dateService', ->
  Date::timeNow = ->
    (if @getHours() < 10 then '0' else '') + @getHours() + ':' + (if @getMinutes() < 10 then '0' else '') + @getMinutes() + ':' + (if @getSeconds() < 10 then '0' else '') + @getSeconds()
  
  Date::addDays = (days) ->
    dat = new Date(@valueOf())
    dat.setDate dat.getDate() + days
    dat

  todayStr = ->
    today = new Date
    dd = today.getDate()
    mm = today.getMonth() + 1
    yyyy = today.getFullYear()
    dd = '0' + dd if dd < 10
    mm = '0' + mm if mm < 10  
    today = yyyy + '-' + mm + '-' + dd

  return {
    getToday: ->
      todayStr()

    getTodayTime: ->
      currentdate = new Date
      datetime = todayStr() + " "+ currentdate.timeNow()

    getDayArray: (startDayString, endDayString) ->
      startDate = new Date(startDayString)
      endDate = new Date(endDayString)
      dateArray = []
      currentDate = startDate
      while currentDate <= endDate
        dateArray.push formatDate(new Date(currentDate))
        currentDate = currentDate.addDays(1)
      dateArray

    formatDate: (date) ->
      d = new Date(date)
      month = '' + (d.getMonth() + 1)
      day = '' + d.getDate()
      year = d.getFullYear()
      if month.length < 2
        month = '0' + month
      if day.length < 2
        day = '0' + day
      [
        year
        month
        day
      ].join '-'
  }