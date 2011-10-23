vows = require 'vows'
assert = require 'assert'

require('../../src/core/string/ruby')

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

      'underscore':
        'word': (topic) ->
          assert.equal topic.underscore('BulletRecord'), 'bullet_record'

        'path': (topic) ->
          assert.equal topic.underscore('BulletRecord::Errors'), 'bullet_record/errors'

      'dasherize':
        'underscored_word': (topic) ->
          assert.equal topic.dasherize('puni_puni'), 'puni-puni'

      'demodulize':
        'module name': (topic) ->
          assert.equal topic.demodulize('BulletRecord.CoreExtensions.Inflections'), 'Inflections'

        'isolated module name': (topic) ->
          assert.equal topic.demodulize('Inflections'), 'Inflections'

      'ordinalize':
        '1st': (topic) ->
          assert.equal topic.ordinalize(1), '1st'

        '2nd': (topic) ->
          assert.equal topic.ordinalize(2), '2nd'

        '1002nd': (topic) ->
          assert.equal topic.ordinalize(1002), '1002nd'

        '1003rd': (topic) ->
          assert.equal topic.ordinalize(1003), '1003rd'

        '-11th': (topic) ->
          assert.equal topic.ordinalize(-11), '-11th'

        '-1021st': (topic) ->
          assert.equal topic.ordinalize(-1021), '-1021st'

  .export(module)
