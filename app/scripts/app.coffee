'use strict'

meanApp = angular.module 'meanApp', ['ngCookies', 'ngResource', 'ngRoute', 'smart-table']
meanApp.constant('_', window._)
meanApp.constant('API_ENDPOINT', 'http://qa.aghchina.com.cn:3000')
meanApp.constant('APP_URL', 'http://qa.aghchina.com.cn:9000')
#meanApp.constant('API_ENDPOINT', 'http://app.aghchina.com.cn:3000')
#meanApp.constant('APP_URL', 'http://app.aghchina.com.cn:9000')
