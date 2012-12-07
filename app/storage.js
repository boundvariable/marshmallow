// Generated by CoffeeScript 1.4.0
(function() {
  var Store, redis, url;

  redis = require('redis');

  url = require('url');

  Store = (function() {
    var MAX_IDLE;

    MAX_IDLE = 2000;

    function Store(key) {
      this.key = key;
      this.keepalive();
    }

    Store.prototype.read = function(from, to, callback) {
      this.keepalive();
      return this.client.ZRANGEBYSCORE(this.key, from, to, function(err, data) {
        return callback(err, data);
      });
    };

    Store.prototype.write = function(timestamp, event, callback) {
      this.keepalive();
      this.client.ZADD(this.key, timestamp, JSON.stringify(event));
      return callback();
    };

    Store.prototype.keepalive = function() {
      var redisUrl, _ref,
        _this = this;
      if ((_ref = this.client) != null ? _ref.connected : void 0) {
        clearTimeout(this.keepaliveTimeout);
      } else {
        if (process.env.REDISTOGO_URL) {
          redisUrl = url.parse(process.env.REDISTOGO_URL);
          this.client = redis.createClient(redisUrl.port, redisUrl.hostname);
          this.client.auth(redisToGoUrl.auth.split(":")[1]);
        } else {
          this.client = redis.createClient();
        }
      }
      return this.keepaliveTimeout = setTimeout(function() {
        return _this.client.quit();
      }, MAX_IDLE);
    };

    return Store;

  })();

  exports.Store = Store;

}).call(this);
