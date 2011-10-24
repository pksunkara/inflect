vows = require 'vows'
assert = require 'assert'

require('../../../src/core/string/ruby')

vows
  .describe('Module core extension Ruby')
  .addBatch
    'Testing value':
      topic: 'bullet'

      'join the keys': (topic) ->
        assert.equal topic.value(), 'bullet'

    'Testing gsub':
      topic: 'bullet'

      'when no args': (topic) ->
        assert.equal topic.gsub(), 'bullet'

      'when only 1 arg': (topic) ->
        assert.equal topic.gsub(/./), 'bullet'

      'when given proper args': (topic) ->
        assert.equal topic.gsub(/[aeiou]/, '*'), 'b*ll*t'

      'when replacement is a function':
        'with many groups': (topic) ->
          str = topic.gsub /([aeiou])(.)/, ($) ->
            "<#{$[1]}>#{$[2]}"
          assert.equal str, 'b<u>ll<e>t'

        'with no groups': (topic) ->
          str = topic.gsub /[aeiou]/, ($) ->
            "<#{$[1]}>"
          assert.equal str, 'b<u>ll<e>t'

      'when replacement is special':
        'with many groups': (topic) ->
          assert.equal topic.gsub(/([aeiou])(.)/, '<$1>$2'), 'b<u>ll<e>t'

        'with no groups': (topic) ->
          assert.equal topic.gsub(/[aeiou]/, '<$1>'), 'b<u>ll<e>t'

    'Testing capitalize':
      topic: 'employee salary'

      'normal': (topic) ->
        assert.equal topic.capitalize(), 'Employee Salary'

    'Testing upcase':
      topic: 'bullet'

      'only first letter should be upcase': (topic) ->
        assert.equal topic.upcase(), 'Bullet'

      'letter after underscore': (topic) ->
        assert.equal 'bullet_record'.upcase(), 'Bullet_Record'

      'letter after slash': (topic) ->
        assert.equal 'bullet_record/errors'.upcase(), 'Bullet_Record/Errors'

      'no letter after space': (topic) ->
        assert.equal 'employee salary'.upcase(), 'Employee salary'

    'Testing downcase':
      topic: 'BULLET'

      'only first letter should be downcase': (topic) ->
        assert.equal topic.downcase(), 'bULLET'

      'letter after underscore': (topic) ->
        assert.equal 'BULLET_RECORD'.downcase(), 'bULLET_rECORD'

      'letter after slash': (topic) ->
        assert.equal 'BULLET_RECORD/ERRORS'.downcase(), 'bULLET_rECORD/eRRORS'

  .export(module)
