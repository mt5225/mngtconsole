logger = require '../config/logger'
auth = require '../config/auth'

mngtuser_service = require '../services/service.mngtuser'


module.exports = (app) ->

  app.get '/mngtusers', auth.basic, (req, res) ->
    logger.info 'get all mngtusers'
    mngtuser_service.getUsers (err, mngtusers) ->
      res.send err, mngtusers

  app.get '/mngtusers/:id', auth.basic, (req, res) ->
    id = req.params.id
    logger.info 'get mngtuser #{id}'
    mngtuser_service.getUser id, (err, mngtuser) ->
      res.send err, mngtuser

  app.post '/signin', auth.none, (req, res) ->

  app.post '/signup', auth.none, (req, res) ->
    logger.info "signup new management user"
    data = req.body
    logger.debug data
    mngtuser_service.createUser data, (err, mngtuser) ->
      if err
        logger.error err
        res.status(500).json err
      else
        res.status(200).json mngtuser

  app.get '/signout', auth.basic, (req, res) ->
    req.logout()
    res.redirect('/')
