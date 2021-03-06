express = require 'express'
{Store} = require './storage'
{fork} = require 'child_process'

app = express()
app.use express.bodyParser()

store = new Store 'events'

asCsv = (fields, data, callback) ->
  if process.env.NO_FORK
    {arrayToCsv} = require './csv'
    callback arrayToCsv(fields, data)
  else
    toCsv = fork "#{__dirname}/csv"
    toCsv.on 'message', (message) ->
      callback message
    toCsv.send {fields, data}

app.post '/events/add', (req, res) ->
  event = req.body
  timestamp = event.timestamp
  if timestamp
    store.write timestamp, event, ->
      res.setHeader 'Content-Type', 'application/json'
      res.status(200).send '{"status": "OK"}'
  else
    res.status(400).send '{"status": "ERROR", message: "timestamp missing"}'

app.get '/csv/events', (req,res) ->
  from = 1*req.query.from
  to = 1*req.query.to
  fields = req.query.fields?.split ','
  if from and to and fields
    store.read from, to, (err, data) ->
      res.setHeader 'Content-Type', 'text/csv'
      asCsv fields, data, (csv) ->
        res.status(200).send csv
  else
    res.status(400).send '{"status": "ERROR", message: "timstamp range missing"}'

port = process.env.PORT || 5000

app.listen port, -> console.log "Listening on port #{port}"

module.exports = app
