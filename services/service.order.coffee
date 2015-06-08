logger = require '../config/logger'

mongoose = require 'mongoose'
Order = mongoose.model 'Order'

module.exports =
  getOrders: (callback) ->
    Order.find {}, (err, order) -> callback err, order

  getOrder: (id, callback) ->
    Order.findOne {id: id}, (err, order) -> callback err, order