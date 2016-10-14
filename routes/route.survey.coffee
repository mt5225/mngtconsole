logger = require '../config/logger'
auth = require '../config/auth'

survey_service = require '../services/service.survey'

module.exports = (app) ->
  app.get '/api/surveys', auth.none, (req, res) ->
    logger.info 'get survey list'
    survey_service.getSurveys (err, surveys) ->
      if err
        logger.error err
        res.status(500).json err
      else
        res.status(200).json surveys
  
  app.get '/api/surveys/:id', auth.none, (req, res) ->
    logger.info "query survey id #{req.params.id}"
    survey_service.getSurveyById  req.params['id'], (err, survey) ->
      if err
        logger.error err
        res.status(500).json err
      else
        res.status(200).json survey

