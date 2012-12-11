request = require 'supertest'
express = require 'express'

app = require '../../src'

describe 'saving data', ->

  it 'should record an event via POST', (done) ->
    event =
      timestamp: Date.now()
      a: 'A'

    request(app)
    .post("/events/add")
    .send(event)
    .expect('Content-Type', /json/)
    .expect(200, '{"status": "OK"}')
    .end(done)

  it 'should return a 400 error when the timestamp is missing', (done) ->
    request(app)
    .post("/events/add")
    .send({})
    .expect(400, done)

describe 'retrieving data', ->

  beforeEach (done) =>
    @event =
      timestamp: Date.now()
      b: 'Zool'

    request(app)
    .post("/events/add")
    .send(@event)
    .end(done)

  it 'should return csv containing events', (done) =>
    csvUrl = "/csv/events?from=#{@event.timestamp-1}&to=#{@event.timestamp+1}&fields=a,b,z"
    expectedCsv = '''
      a,b,z
      ,Zool,
      '''

    request(app)
    .get(csvUrl)
    .expect('Content-Type', /csv/)
    .expect(200, expectedCsv)
    .end(done)
