mongoose = require 'mongoose'
Schema = mongoose.Schema
houses = {}
for num in [1..99]
  if num < 10 
    id = 'H00' + num
  else
    id = 'H0' + num
  houses[id] = mongoose.model(id, new Schema({}, strict: false))
module.exports = houses
    