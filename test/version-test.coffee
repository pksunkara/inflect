vows = require 'vows'
assert = require 'assert'

vows
  .describe('Test version of the module')
  .addBatch
    'When we check the versions':
      topic: require '../src/version'

      'we get':
        'MAJOR value of version': (topic) ->
          assert.equal topic.MAJOR, '1'

        'MINOR value of version': (topic) ->
          assert.equal topic.MINOR, '0'

        'TINY value of version': (topic) ->
          assert.equal topic.TINY, '0'

        'PRE value of version': (topic) ->
          assert.equal topic.PRE, 'rc1'

        'Value of version': (topic) ->
          assert.equal topic.VERSION, '1.0.0-rc1'

  .export(module)
