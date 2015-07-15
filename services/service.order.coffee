logger = require '../config/logger'

mongoose = require 'mongoose'
Order = mongoose.model 'Order'

module.exports =
  getOrders: (callback) ->
    Order.find {}, (err, order) -> callback err, order

  getOrder: (id, callback) ->
    console.log "query orderId = #{id}"
    Order.findOne {orderId: id}, (err, order) -> callback err, order

  updateOrder: (req, callback) ->
    order = new Order(req.body)
    upsertData = order.toObject()
    delete upsertData._id
    Order.update({orderId: order.orderId}, upsertData, {upsert: true}, (err) ->
      callback err, order
    )