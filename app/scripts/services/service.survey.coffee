meanApp = angular.module('meanApp')
meanApp.service 'SurveyService', ($resource) ->
    console.log "Survey Service"
    return $resource '/api/surveys/:surveyId', { surveyId: '@_id'}


