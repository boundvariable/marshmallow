express = require 'express'
{Store} = require './storage'
{fork} = require 'child_process'

app = express()

store = new Store 'events'

asCsv = (fields, data, callback) ->
  toCsv = fork __dirname + '/csv'
  toCsv.on 'message', (message) ->
    callback message
  toCsv.send {fields, data}

app.get '/events/:user', (req, res) ->
  event = req.query
  timestamp = event.timestamp
  store.write timestamp, event, ->
    res.status(200).send "{status: OK}"

app.get '/csv/events', (req,res) ->
  from = 1*req.query.from
  to = 1*req.query.to
  fields = req.query.fields?.split ','
  if from and to and fields
    store.read from, to, (err, data) ->
      res.setHeader 'Content-Type', 'text/plain' #'text/csv'
      asCsv fields, data, (lines) ->
        result = """
        #{fields.join ','}
        #{lines.join '\n'}
        """
        res.status(200).send result
  else
    res.status(400).send '400'

app.listen 8080

