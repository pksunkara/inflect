(function() {
  var assert, vows;

  vows = require('vows');

  assert = require('assert');

  require('../../lib/utils/array');

  vows.describe('Module core extension Array').addBatch({
    'Testing del': {
      topic: ['a', 'b', 'c'],
      'element exists': {
        'first element': function(topic) {
          return assert.deepEqual(topic.del('a'), ['b', 'c']);
        },
        'middle element': function(topic) {
          return assert.deepEqual(topic.del('b'), ['a', 'c']);
        },
        'last element': function(topic) {
          return assert.deepEqual(topic.del('c'), ['a', 'b']);
        }
      },
      'element does not exist': function(topic) {
        return assert.deepEqual(topic.del('d'), ['a', 'b', 'c']);
      }
    },
    'Testing utils': {
      topic: ['a', 'b', 'c'],
      'first': function(topic) {
        return assert.equal(topic.first(), 'a');
      },
      'last': function(topic) {
        return assert.equal(topic.last(), 'c');
      }
    }
  })["export"](module);

}).call(this);
