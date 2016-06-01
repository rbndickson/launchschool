(function() {
  var findObjs = function(element, properties, multiple) {
    var match = multiple ? [] : undefined;

    element.some(function(obj) {
      // the function is buit into the params of the some method.
      // obj is each obj in element.
      // some used to return as soon as a match has been found for nonmultiples.
      var prop_value_match = true;
      for (var property in properties) {
        if (!(property in obj) || obj[property] !== properties[property]) {
          prop_value_match = false;
        }
      }

      if (prop_value_match) {
        if (multiple) {
          match.push(obj);
        }
        else {
          match = obj;
          return true;
        }
      }
    });

    return match;
  };

  var _ = function(element) {
    u = {
      first: function() {
        return element[0];
      },
      last: function() {
        return element[element.length - 1];
      },
      without: function() {
        var args = Array.prototype.slice.call(arguments);
        var result = [];

        for (var i = 0; i < element.length; i++) {
          if (!args.includes(element[i])) { result.push(element[i]); }
        }
        return result;
      },
      lastIndexOf: function(element_wanted) {
        var last_index;

        for (var i = 0; i < element.length; i++) {
          if (element[i] === element_wanted) { last_index = i; }
        }
        return last_index;
      },
      sample: function(quantity) {
        var random_index;
        var getRandomIndex = function(array_length) {
          return Math.floor(Math.random() * array_length);
        };

        if (quantity) {
          var arr = element;
          var result = [];

          for (var i = 0; i < quantity; i++) {
            random_index = getRandomIndex(arr.length);
            result.push(arr[random_index]);
            arr = _(arr).without(arr[random_index]);
          }
          return result;
        }
        else {
          random_index = getRandomIndex(element.length);
          return element[random_index];
        }
      },
      findWhere: function(properties) {
        return findObjs(element, properties, false);
      },
      where: function(properties) {
        return findObjs(element, properties, true);
      },
      pluck: function(property) {
        var matches = [];

        element.forEach(function(obj) { // obj here is like |obj| in Ruby
          if (property in obj) { matches.push(obj[property]); }
        });

        return matches;
      },
      keys: function() {
        return Object.keys(element);
      },
      values: function() {
        var result = [];

        Object.keys(element).forEach(function(key) {
          result.push(element[key]);
        });

        return result;
      },
      pick: function(property) {
        var new_obj = {};
        
        new_obj[property] = element[property];
        return new_obj;
      },
      omit: function() {
        var new_obj = {};
        var args = Array.prototype.slice.call(arguments);
        // can also use [].slice.call(arguments);

        Object.keys(element).forEach(function(property) {
          if (!(args.includes(property))) {
            new_obj[property] = element[property];
          }
        });
        return new_obj;
      },
      has: function(property) {
        return Object.hasOwnProperty.call(element, property);
        // can also use {}.hasOwnProperty.call(arguments);
      },
    };

    (["isElement", "isArray", "isObject", "isFunction", "isBoolean",
      "isString", "isNumber"]).forEach(function(method) {
      u[method] = function() { _[method].call(u, element); };
    });

    return u;
    // returns the utility object
  };

  _.range = function(limit_1, limit_2) {
    var result = [];
    var upper_limit = ( limit_2 || limit_1 );
    var lower_limit = ( limit_2 ? limit_1 : 0 );

    for (var i = lower_limit; i < upper_limit; i++) {
      result.push(i);
    }
    return result;
  };
  _.extend = function() {
    var args = Array.prototype.slice.call(arguments);
    var first_object = args[0];

    for (var i = 1; i < args.length; i++ ) {
      for (var attrname in args[i]) {
        first_object[attrname] = args[i][attrname];
      }
    }
    return first_object;
  };
  _.isElement = function(obj) {
    return obj && obj.nodeType === 1;
    // this pattern of checking a var is defined is called a short circuit
  };
  _.isArray = Array.isArray || function(obj) {
    return toString.call(obj) === "[object Array]";
  };
  _.isObject = function(obj) {
    var type = typeof obj;

    return type === "function" || type === "object" && !!obj;
  };
  _.isFunction = function(obj) {
    var type = typeof obj;

    return type === "function";
  };

  (["Boolean", "String", "Number"]).forEach(function(method) {
    _["is" + method] = function(obj) {
      return toString.call(obj) === "[object " + method + "]";
    };
  });

  window._ = _;
})();
