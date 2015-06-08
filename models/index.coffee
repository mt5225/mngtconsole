fs = require 'fs'
path = require 'path'
logger = require '../config/logger'

module.exports = () ->

  fs.readdirSync(__dirname).forEach (file) ->
    filePath = path.join __dirname, file
    unless filePath is __filename
      baseFilename = path.basename file, path.extname(file)
      model = path.join __dirname, baseFilename
      logger.debug "load module #{model}"
      require(model)