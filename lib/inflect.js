// Requiring modules

(function() {
  if (typeof module !== 'undefined') {
    module.exports = exportModule(require('./methods'), require('./native'));
  } else if (typeof define === 'function' && define.amd) {
    define(['./methods', './native'], exportModule);
  }

  function exportModule(methods, nativeModule) {
    return function (attach) {
      if (attach) {
        nativeModule(methods);
      }
      return methods;
    };
  }
})();
