logger = require '../config/logger'
mongoose = require 'mongoose'
Cal = {}
for num in [1..12]
  if num < 10 
    id = 'H00' + num
  else
    id = 'H0' + num
  Cal[id] = mongoose.model id


###
return to query
   {"2015-06-19":{"available":1,"bind":3,"info":"","notes":"","price":10,"promo":0,"status":"available"},"2015-06-09":{"available":1,"bind":0,"info":"aa","notes":"bb","price":1200,"promo":1100,"status":"available"}}
###
module.exports =
  getCal: (data, houseId, callback) ->
    data = {}
    Cal[houseId].find().lean().exec (err, records) ->
      for item in records
        data[item['day']] = item['info']
      data = JSON.stringify(data)
      console.log data
      callback data
  
  saveCal: (data, houseId, callback) ->
    dopbcp_schedule = JSON.parse(data['dopbcp_schedule'])
    for item of dopbcp_schedule
      record = {}
      record['day'] = item
      record['info'] = dopbcp_schedule[item]
      Cal[houseId].findOneAndUpdate {'day': item}, record, {upsert:true}, (err, doc) ->
        callback err


###
//////////////////////
// raw post
//////////////////////
{ 
  dopbcp_calendar_id: '1',
  dopbcp_schedule: '{"2015-06-19":{"available":1,"bind":3,"info":"","notes":"","price":10,"promo":0,"status":"available"},"2015-06-09":{"available":1,"bind":0,"info":"aa","notes":"bb","price":1200,"promo":1100,"status":"available"}}' 
}
///////////////////////
// save to database
///////////////////////
" : 1 }, "__v" : 0 }
{ "_id" : ObjectId("557833b7f7e7c9a6abc3cd23"), "day" : "2015-06-14", "info" : { "status" : "available", "promo" : 0, "price" : 0, "notes" : "", "info" : "", "bind" : 0, "available" : 1 }, "__v" : 0 }
###

