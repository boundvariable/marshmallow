
process.on 'message', (message) ->
  csv = (raw) ->
    o = JSON.parse raw
    (o[field] || '' for field in message.fields).join ','
  csvItems = (csv item for item in message.data)
  process.send csvItems
  process.exit()
