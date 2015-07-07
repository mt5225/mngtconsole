base =
  ENV: process.env.NODE_ENV || 'development'
  PORT: process.env.PORT || 3033
  LOGPATH: "mngtconsole.log"
  COOKIE_SECRET: "kknd"
  DBURLTEST: "mongodb://localhost/perfectlife"

dev =
  DBURL: "mongodb://localhost/perfectlife"

prod =
  DBURL: "mongodb://localhost/perfectlife"

orderscaner =
  LOGPATH: "orderscaner.log"
  DBURL: "mongodb://localhost/perfectlife"
  ORDER_EXPIRE_MINUTES : 30
  INTERVAL_SECOND : 5

mergeConfig = (config) ->
  for key, val of config
    base[key] = val
  base

module.exports = ( ->
  switch base.ENV
    when 'development' then return mergeConfig(dev)
    when 'production' then return mergeConfig(prod)
    when 'orderscaner' then return mergeConfig(orderscaner)
    else return mergeConfig(dev)
)()



