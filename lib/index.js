// Generated by CoffeeScript 1.10.0
var loopify,
  slice = [].slice;

module.exports = loopify = function() {
  var action, arg, handle, i, promise, sleep, start, stop;
  arg = 2 <= arguments.length ? slice.call(arguments, 0, i = arguments.length - 1) : (i = 0, []), action = arguments[i++];
  sleep = arg[0];
  if ("function" !== typeof action) {
    throw new TypeError("Invalid callback");
  }
  sleep = +sleep;
  handle = null;
  start = -Infinity;
  stop = false;
  promise = new Promise(function(resolve, reject) {
    var _loop;
    _loop = function() {
      var err, error, p;
      if (stop) {
        return resolve();
      }
      try {
        p = Promise.resolve(action());
      } catch (error) {
        err = error;
        if (err != null) {
          return reject(err);
        } else {
          return resolve();
        }
      }
      p.then(function() {
        var now, timeout;
        if (sleep > 0) {
          now = new Date().getTime();
          timeout = start + sleep - now;
          start = now;
          return handle = setTimeout(_loop, timeout > 0 ? timeout : 0);
        } else {
          return handle = setTimeout(_loop, 0);
        }
      });
      return p["catch"](function(err) {
        return reject(err);
      });
    };
    return _loop();
  });
  promise.cancel = function() {
    stop = true;
    return clearTimeout(handle);
  };
  return promise;
};