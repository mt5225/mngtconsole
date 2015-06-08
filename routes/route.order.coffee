logger = require '../config/logger'
auth = require '../config/auth'

order_service = require '../services/service.order'

module.exports = (app) ->
  app.get '/api/orders', auth.none, (req, res) ->
    logger.info 'get order list'
    order_service.getOrders (err, orders) ->
      if err
        logger.error err
        res.status(500).json err
      else
        res.status(200).json orders