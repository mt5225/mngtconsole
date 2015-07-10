logger = require '../config/logger'

mongoose = require 'mongoose'
House = mongoose.model 'House'

module.exports =

  getHouses: (callback) ->
    House.find {}, (err, house) -> callback err, house

  getHouseById: (id, callback) ->
    House.findOne {id: id}, (err, house) -> callback err, house

  updateHouse: (id, req, callback) ->
    House.findOne (id: id), (err, house) ->
      for field of House.schema.paths
        if field isnt '_id' and field isnt '__v'
          if req.body[field]?
            house[field] = req.body[field]
      house.save()
      callback err, house