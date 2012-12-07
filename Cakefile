fs = require 'fs'
{spawn, exec, execFile, fork} = require 'child_process'

clean = (path, callback) ->
  console.log "Cleaning #{path}"
  exec "rm -rf #{path}", -> callback?()

compiled = false
compile = (source, destination, callback) ->
  return if compiled
  coffee = spawn 'coffee', ['-c', '-o', destination, source]
  coffee.on 'exit', (code) ->
    if code is 0
      compiled = true
      callback?()

courier = (callback) ->
  console.log 'Running courier'
  exec 'courier', (err, out) ->
    console.log out if out
    callback?()


task 'build', 'Builds the entire application', ->
  courier ->
    clean 'app', ->
      compile 'src', 'app', ->
        console.log 'All done'
