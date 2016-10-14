logger = require '../config/logger'

mongoose = require 'mongoose'
Survey = mongoose.model 'Survey'

module.exports =
  getSurveys: (callback) ->
    Survey.find {}, (err, surveys) -> callback err, surveys

  getSurveyById: (id, callback) ->
    Survey.findOne {_id: id}, (err, survey) -> callback err, survey