logger = require '../config/logger'

mongoose = require 'mongoose'
House = mongoose.model 'House'

module.exports =

  getHouses: (callback) ->
    House.find {}, (err, house) -> callback err, house

  getHouseById: (id, callback) ->
    House.findOne {id: id}, (err, house) -> callback err, house