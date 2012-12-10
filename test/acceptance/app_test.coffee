request = require 'supertest'
express = require 'express'

app = require '../../src'

describe 'saving data', ->

  it 'should record an event', (done) ->

    event =
      timestamp: Date.now()
      a: 'A'

    eventUrl = "/events/add?timestamp=#{event.timestamp}&a=#{event.a}"

    request(app)
    .get(eventUrl)
    .expect('Content-Type', /json/)
    .expect(200, '{"status": "OK"}')
    .end(done)

describe 'retrieving data', ->

  beforeEach (done) =>
    @event =
      timestamp: Date.now()
      b: 'Zool'

    eventUrl = "/events/add?timestamp=#{@event.timestamp}&b=#{@event.b}"
    request(app)
    .get(eventUrl)
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
