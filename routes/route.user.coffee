logger = require '../config/logger'
auth = require '../config/auth'

user_service = require '../services/service.user'

module.exports = (app) ->
  app.get '/api/users', auth.none, (req, res) ->
    logger.info 'get user list'
    user_service.getUsers (err, users) ->
      if err
        logger.error err
        res.status(500).json err
      else
        res.status(200).json users

  app.get '/api/users/:openid', auth.none, (req, res) ->
    logger.info 'get user by id'
    openid = req.params['openid']
    user_service.getUserById openid, (err, user) ->
      if err
        logger.error err
        res.status(500).json err
      else
        res.status(200).json user

  app.post '/api/users/:openid', auth.none, (req, res) ->
    logger.info req.body
    user_service.updateUser req, (err, user) ->
      if err
        logger.error err
        res.status(500).json err
      else
        res.status(200).json user