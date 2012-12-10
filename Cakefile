fs = require 'fs'
{spawn, exec, execFile, fork} = require 'child_process'

clean = (path, callback) ->
  console.log "Cleaning #{path}"
  exec "rm -rf #{path}", -> callback?()

compiled = false
compile = (source, destination, callback) ->
  console.log 'Compiling CoffeeScript'
  return if compiled
  coffee = spawn 'coffee', ['-c', '-o', destination, source]
  coffee.on 'exit', (code) ->
    if code is 0
      compiled = true
      callback?()

test = (callback) ->
  console.log 'Running tests'
  reporter = "min"
  testExecHandler = (err, output) ->
   throw err if err
   console.log output
   callback?()

  exec "NODE_ENV=test
    ./node_modules/.bin/mocha
    --recursive
    --compilers coffee:coffee-script
    --reporter #{reporter}
    --require coffee-script
    --require test/test_helper.coffee
    --colors
  ", testExecHandler

courier = (callback) ->
  console.log 'Running courier'
  exec 'courier', (err, out) ->
    console.log out if out
    callback?()

task 'test', 'Runs all the tests', ->
  test()

task 'build', 'Builds the application', ->
  courier ->
    test ->
      clean 'app', ->
        compile 'src', 'app', ->
          console.log 'All done'
