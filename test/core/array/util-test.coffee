vows = require 'vows'
assert = require 'assert'

require('../../../src/core/array/util')

vows
  .describe('Module core extension Array Util')
  .addBatch
    'Testing del':
      topic: ['a', 'b', 'c']

      'element exists':
        'first element': (topic) ->
          assert.deepEqual topic.del('a'), ['b', 'c']

        'middle element': (topic) ->
          assert.deepEqual topic.del('b'), ['a', 'c']

        'last element': (topic) ->
          assert.deepEqual topic.del('c'), ['a', 'b']

      'element does not exist': (topic) ->
        assert.deepEqual topic.del('d'), ['a', 'b', 'c']

  .export(module)
