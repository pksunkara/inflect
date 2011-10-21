vows = require 'vows'
assert = require 'assert'

require('../../src/core/string/ruby') String

vows
  .describe('Module Inflector methods')
  .addBatch
    'Test inflector method':
      topic: require '../../src/inflector/methods'

      'camelize':
        'word': (topic) ->
          assert.equal topic.camelize('bullet_record'), 'BulletRecord'

        'word with first letter lower': (topic) ->
          assert.equal topic.camelize('bullet_record', false), 'bulletRecord'

        'path': (topic) ->
          assert.equal topic.camelize('bullet_record/errors'), 'BulletRecord::Errors'

        'path with first letter lower': (topic) ->
          assert.equal topic.camelize('bullet_record/errors', false), 'bulletRecord::Errors'

  .export(module)
