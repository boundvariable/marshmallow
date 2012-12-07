redis = require 'redis'
url = require 'url'

class Store
  MAX_IDLE = 2000

  constructor: (@key) ->
    @keepalive()

  read: (from, to, callback) ->
    @keepalive()
    @client.ZRANGEBYSCORE @key, from, to, (err, data) ->
      callback err, data

  write: (timestamp, event, callback) ->
    @keepalive()
    @client.ZADD @key, timestamp, JSON.stringify event
    callback()

  keepalive: ->
    if @client?.connected
      clearTimeout @keepaliveTimeout
    else
      if process.env.REDISTOGO_URL
        redisUrl = url.parse process.env.REDISTOGO_URL
        @client = redis.createClient redisUrl.port, redisUrl.hostname
        @client.auth redisUrl.auth.split(":")[1]
      else
        @client = redis.createClient()
    @keepaliveTimeout = setTimeout =>
      @client.quit()
    , MAX_IDLE

exports.Store = Store
