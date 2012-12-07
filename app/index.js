// Generated by CoffeeScript 1.4.0
(function() {
  var Store, app, asCsv, express, fork, port, store;

  express = require('express');

  Store = require('./storage').Store;

  fork = require('child_process').fork;

  app = express();

  store = new Store('events');

  asCsv = function(fields, data, callback) {
    var toCsv;
    toCsv = fork(__dirname + '/csv');
    toCsv.on('message', function(message) {
      return callback(message);
    });
    return toCsv.send({
      fields: fields,
      data: data
    });
  };

  app.get('/events/:user', function(req, res) {
    var event, timestamp;
    event = req.query;
    timestamp = event.timestamp;
    return store.write(timestamp, event, function() {
      return res.status(200).send("{status: OK}");
    });
  });

  app.get('/csv/events', function(req, res) {
    var fields, from, to, _ref;
    from = 1 * req.query.from;
    to = 1 * req.query.to;
    fields = (_ref = req.query.fields) != null ? _ref.split(',') : void 0;
    if (from && to && fields) {
      return store.read(from, to, function(err, data) {
        res.setHeader('Content-Type', 'text/csv');
        return asCsv(fields, data, function(lines) {
          var result;
          result = "" + (fields.join(',')) + "\n" + (lines.join('\n'));
          return res.status(200).send(result);
        });
      });
    } else {
      return res.status(400).send('400');
    }
  });

  port = process.env.PORT || 5000;

  app.listen(port, function() {
    return console.log("Listening on port " + port);
  });

}).call(this);