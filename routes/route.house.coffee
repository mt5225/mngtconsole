logger = require '../config/logger'
auth = require '../config/auth'

house_service = require '../services/service.house'

module.exports = (app) ->
  app.get '/api/houses', auth.none, (req, res) ->
    logger.info 'get house list'
    house_service.getHouses (err, houses) ->
      if err
        logger.error err
        res.status(500).json err
      else
        res.status(200).json houses

  app.get '/api/houses/:id', auth.none, (req, res) ->
    logger.info "get house by id = #{req.params['id']}"
    id = req.params['id']
    house_service.getHouseById id, (err, house) ->
      if err
        logger.error err
        res.status(500).json err
      else
        res.status(200).json house

  app.post '/api/houses/:id', auth.none, (req, res) ->
    id = req.params['id']
    house_service.updateHouse id, req, (err, order) ->
      if err
        logger.error err
        res.status(500).json err
      else
        res.status(200).json order