mongoose = require 'mongoose'
Schema = mongoose.Schema

OrderSchema = new Schema (
  orderId: String
  houseId: String
  checkInDay: String
  checkOutDay: String
  numOfGuest: String
  numOfGuestChild: String
  wechatOpenID: String
  wechatNickName: String
  status: String
  createDay: String
  houseId: String
  houseName: String
  totalPrice: String
  priceByDayArray:  { type : Array , "default" : [] }
  memo: String
  plan: String
)

module.exports = mongoose.model('Order', OrderSchema)

