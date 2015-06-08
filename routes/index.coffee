fs = require 'fs'
path = require 'path'
logger = require '../config/logger'

module.exports = (app) ->
  fs.readdirSync(app.settings.routes).forEach((file) ->
    filePath = path.join app.settings.routes, file
    unless filePath is __filename
      baseFilename = path.basename file, path.extname(file)
      route = path.join app.settings.routes, baseFilename
      logger.debug "loade routes #{route}"
      require(route)(app)
  )