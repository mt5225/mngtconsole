mongoose = require 'mongoose'
Schema = mongoose.Schema

Cal = new Schema({}, strict: false)
module.exports = mongoose.model('Cal', Cal)