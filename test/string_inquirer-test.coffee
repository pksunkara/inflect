vows = require 'vows'
assert = require 'assert'

vows
  .describe('Module StringInquirer')
  .addBatch
    'Test string equality':
      topic: ->
        StringInquirer = require '../src/string_inquirer'
        new StringInquirer('production')

      'when they are':
        'equal': (topic) ->
          assert.isTrue topic.$('production')

        'not equal': (topic) ->
          assert.isFalse topic.$('staging')

  .export(module)
