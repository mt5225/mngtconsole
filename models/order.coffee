mongoose = require 'mongoose'
Schema = mongoose.Schema

Order = new Schema(
    orderId: String,
    houseId: String,
    checkInDay: String,
    checkOutDay: String,
    numOfGuest: String,
    wechatOpenID: String,
    wechatNickName: String,
    Other: String
)

module.exports = mongoose.model('Order', Order)

