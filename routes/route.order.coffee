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

  app.get '/api/orders/:orderId', auth.none, (req, res) ->
    orderId = req.params['orderId']
    order_service.getOrder orderId, (err, order) ->
      if err
        logger.error err
        res.status(500).json err
      else
        res.status(200).json order

  app.post '/api/orders/:orderId', auth.none, (req, res) ->
    order_service.updateOrder req, (err, order) ->
      if err
        logger.error err
        res.status(500).json err
      else
        res.status(200).json order

  app.post '/api/orders', auth.none, (req, res) ->
    order_service.updateOrder req, (err, order) ->
      if err
        logger.error err
        res.status(500).json err
      else
        res.status(200).json order