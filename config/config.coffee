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

mergeConfig = (config) ->
  for key, val of config
    base[key] = val
  base

module.exports = ( ->
  switch base.ENV
    when 'development' then return mergeConfig(dev)
    when 'production' then return mergeConfig(prod)
    else return mergeConfig(dev)
)()



