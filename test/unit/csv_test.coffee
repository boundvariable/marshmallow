
csv = require '../../src/csv'

describe 'csv arrayToCsv', ->
  it 'should convert an array to csv with specified fields', ->
    fields = ['a', 'b']
    data = [
      JSON.stringify({a: 1, b: 2, c: 3}),
      JSON.stringify({c: 3}),
      JSON.stringify({b: 3, z: 11})
    ]

    expect(csv.arrayToCsv(fields, data)).to.equal '''
      a,b
      1,2
      ,
      ,3
    '''