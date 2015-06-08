passwordHash = require 'password-hash'
mongoose = require 'mongoose'
Schema = mongoose.Schema

MngtUser = new Schema(
  username:
    type: String
    unique: true
    required: true

  hashed_password:
    type: String
    required: true
)

MngtUser.virtual('password').set (password) ->
  options =
    algorithm: 'sha256',
    iterations: 1024,
    saltLength: 10
  @hashed_password = passwordHash.generate password, options

MngtUser.methods.authenticate = (plainText) ->
  passwordHash.verify(plainText, @hashed_password)

module.exports = mongoose.model('MngtUser', MngtUser)