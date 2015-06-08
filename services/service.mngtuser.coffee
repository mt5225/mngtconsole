logger = require '../config/logger'

mongoose = require 'mongoose'
MngtUser = mongoose.model 'MngtUser'

module.exports =

  getUsers: (callback) ->
    MngtUser.find {}, (err, user) -> callback err, user

  getUser: (id, callback) ->
    MngtUser.findOne {_id: id}, (err, user) -> callback err, user

  createUser: (data, callback) ->
    logger.debug "create new admin user #{JSON.stringify(data)}"
    mngtuser = new MngtUser(data)
    mngtuser.save (err) -> 
      callback err, mngtuser

  deleteUser: (id, callback) ->
    MngtUser.findOneAndRemove {'_id': id}, (err, user) -> callback err, user







