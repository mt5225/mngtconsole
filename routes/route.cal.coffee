logger = require '../config/logger'
auth = require '../config/auth'

order_cal = require '../services/service.cal'

module.exports = (app) ->
  app.post '/api/cal/loadcal', auth.none, (req, res) ->
    console.log req.body
    order_cal.getCal req.body, (calbody) ->
        res.status(200).json calbody

  app.post '/api/cal/savecal', auth.none, (req, res) ->
    console.log req.body
    order_cal.saveCal req.body, (err) ->
    res.status(200).json ''