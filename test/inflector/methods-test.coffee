vows = require 'vows'
assert = require 'assert'

require('../../src/core/string/ruby')

cases = require './cases'

vows
  .describe('Module Inflector methods')
  .addBatch
    'Test inflector method':
      topic: require '../../src/inflector/methods'

      'camelize':
        'word': (topic) ->
          words = cases.CamelToUnderscore
          assert.equal topic.camelize(words[i]), i for i in Object.keys words

        'word with first letter lower': (topic) ->
          words = cases.UnderscoreToLowerCamel
          assert.equal topic.camelize(i, false), words[i] for i in Object.keys words

        'path': (topic) ->
          words = cases.CamelWithModuleToUnderscoreWithSlash
          assert.equal topic.camelize(words[i]), i for i in Object.keys words

        'path with first letter lower': (topic) ->
          assert.equal topic.camelize('bullet_record/errors', false), 'bulletRecord.Errors'

      'underscore':
        'word': (topic) ->
          words = cases.CamelToUnderscore
          assert.equal topic.underscore(i), words[i] for i in Object.keys words
          words = cases.CamelToUnderscoreWithoutReverse
          assert.equal topic.underscore(i), words[i] for i in Object.keys words

        'path': (topic) ->
          words = cases.CamelWithModuleToUnderscoreWithSlash
          assert.equal topic.underscore(i), words[i] for i in Object.keys words

      'dasherize':
        'underscored_word': (topic) ->
          words = cases.UnderscoresToDashes
          assert.equal topic.dasherize(i), words[i] for i in Object.keys words

      'demodulize':
        'module name': (topic) ->
          assert.equal topic.demodulize('BulletRecord.CoreExtensions.Inflections'), 'Inflections'

        'isolated module name': (topic) ->
          assert.equal topic.demodulize('Inflections'), 'Inflections'

      'foreign_key':
        'normal': (topic) ->
          words = cases.ClassNameToForeignKeyWithoutUnderscore
          assert.equal topic.foreign_key(i, false), words[i] for i in Object.keys words

        'with_underscore': (topic) ->
          words = cases.ClassNameToForeignKeyWithUnderscore
          assert.equal topic.foreign_key(i), words[i] for i in Object.keys words

      'ordinalize': (topic) ->
        words = cases.OrdinalNumbers
        assert.equal topic.ordinalize(i), words[i] for i in Object.keys words

  .export(module)
