
arrayToCsv = (fields, array) ->
  csv = (raw) ->
    o = JSON.parse raw
    (o[field] || '' for field in fields).join ','

  lines = (csv item for item in array)
  """
  #{fields.join ','}
  #{lines.join '\n'}
  """

process.on 'message', (message) ->
  csvItems = arrayToCsv message.fields, message.data
  process.send csvItems
  process.exit()

exports.arrayToCsv = arrayToCsv