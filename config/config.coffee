base =
  ENV: process.env.NODE_ENV || 'qa'
  PORT: process.env.PORT || 3033
  LOGPATH: "mngtconsole.log"
  COOKIE_SECRET: "kknd"
  DBURLTEST: "mongodb://localhost/perfectlife"

qa =
  DBURL: "mongodb://localhost/perfectlife"
  LOGPATH: "orderscaner.log"
  DBURL: "mongodb://localhost/perfectlife"
  ORDER_EXPIRE_MINUTES : 60*24
  INTERVAL_SECOND : 18000

prod =
  DBURL: "mongodb://localhost/perfectlife"
  LOGPATH: "orderscaner.log"
  DBURL: "mongodb://localhost/perfectlife"
  ORDER_EXPIRE_MINUTES : 60*24
  INTERVAL_SECOND : 18000

mergeConfig = (config) ->
  for key, val of config
    base[key] = val
  base

module.exports = ( ->
  switch base.ENV
    when 'qa' then return mergeConfig(qa)
    when 'prod' then return mergeConfig(prod)
    else return mergeConfig(dev)
)()


