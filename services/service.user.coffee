logger = require '../config/logger'

mongoose = require 'mongoose'
User = mongoose.model 'User'

module.exports =
  getUsers: (callback) ->
    User.find {}, (err, users) -> callback err, users

  getUserById: (openid, callback) ->
    User.findOne {openid: openid}, (err, user) -> callback err, user

  updateUser: (req, callback) ->
    User.findOne (openid: req.body['openid']), (err, user) ->
      for field of User.schema.paths
        if field isnt '_id' and field isnt '__v'
          if req.body[field]?
            user[field] = req.body[field]
      user.save()
      callback err, user
    