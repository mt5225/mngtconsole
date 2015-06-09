logger = require '../config/logger'
mongoose = require 'mongoose'
Cal = mongoose.model 'Cal'

module.exports =
  getCal: (calendar_id, callback) ->
    data = """
    {"2015-06-19":{"available":1,"bind":3,"info":"","notes":"","price":10,"promo":0,"status":"available"}}
    """
    callback data
  
  saveCal: (data, callback) ->
    dopbcp_schedule = JSON.parse(data['dopbcp_schedule'])
    for item of dopbcp_schedule
      record = {}
      record[item] = dopbcp_schedule[item]
      console.log record
      cal = new Cal(record)
      cal.save (err) ->
        callback err


