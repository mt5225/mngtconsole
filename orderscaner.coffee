process.env.NODE_ENV = "orderscaner"

# dependencies
_ = require 'lodash'
Q = require 'q'
config = require './config/config'
logger = require './config/logger'
dayArray = require './dayarray'
mongoose = require 'mongoose'
require './models/order'
require './models/house'
require './models/cal'
Order = mongoose.model 'Order'
House = mongoose.model 'House'
HouseCal = {}
for num in [1..99]
  if num < 10 
    id = 'H00' + num
  else
    id = 'H0' + num
  HouseCal[id] = mongoose.model id

mark_expired_order_as_cancel = (order) ->
  logger.info "scan order [#{order.orderId}] submit time : #{order.createDay} status: #{order.status}"
  submitTime = ((new Date).getTime() - new Date(order.createDay).getTime()) / (1000 * 60)
  if submitTime > config.ORDER_EXPIRE_MINUTES
    logger.info "order #{order.orderId} age #{submitTime} > #{config.ORDER_EXPIRE_MINUTES} minutes, change status from '#{order.status}' to '订单取消'."
    Q(Order.update({ orderId: order.orderId }, { $set: status: "订单取消" }).exec())
    .then () ->
      release_house order

#get list of unpay and expired orders
get_expired_order = () ->
  console.log "query expired orders"
  query = { $and: [ {status: { $ne: "订单取消" }}, {status: { $ne: "预订成功" }} ] }
  Order.find(query).exec()

mark_avaible = (cal, dayStr) ->
  cal.update({day: dayStr}, {$set: "info.status": "available"}).exec()

release_house = (order) ->
  console.log order
  dayRangeArray = dayArray.getDayArray(order.checkInDay, order.checkOutDay)
  dayRangeArray.pop()
  console.log dayRangeArray
  promises = _.map dayRangeArray, (dayStr) ->
    logger.info "[#{order.houseName}] set #{dayStr} as available."
    mark_avaible HouseCal[order.houseId], dayStr
  return promises

mongoose.connect config.DBURL
setInterval ( () ->
  logger.info "starting order scanner with interval #{config.INTERVAL_SECOND}"
  logger.info "mongo connected to", config.DBURL
  Q(get_expired_order())
  .then (orders) ->
    logger.info "got all expired orders"
    promises = _.map orders, (order) ->
      mark_expired_order_as_cancel order
    Q.all(promises)
    .then (tasks)->
      logger.info "scan finished, exit."
  .catch (err) ->
    logger.info err
    process.exit 1
), config.INTERVAL_SECOND * 1000



