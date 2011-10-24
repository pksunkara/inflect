vows = require 'vows'
assert = require 'assert'

require('../../src/core/array/util')

vows
  .describe('Module Inflector inflections')
  .addBatch
    'Test inflector inflections':
      topic: ->
        Inflections = require('../../src/inflector/inflections').Inflections
        new Inflections()

      'clear':
        'single': (topic) ->
          topic.uncountables = [1, 2, 3]
          topic.humans = [1, 2, 3]
          topic.clear 'uncountables'
          assert.isEmpty topic.uncountables
          assert.deepEqual topic.humans, [1, 2, 3]

        'all': (topic) ->
          assert.deepEqual topic.humans, [1, 2, 3]
          topic.uncountables = [1, 2, 3]
          topic.clear()
          assert.isEmpty topic.uncountables
          assert.isEmpty topic.humans

      'uncountable':
        'one item': (topic) ->
          assert.isEmpty topic.uncountables
          topic.uncountable 'money'
          assert.deepEqual topic.uncountables, ['money']

        'many items': (topic) ->
          topic.clear 'uncountables'
          assert.isEmpty topic.uncountables
          topic.uncountable ['money', 'rice']
          assert.deepEqual topic.uncountables, ['money', 'rice']

      'human': (topic) ->
        assert.isEmpty topic.humans
        topic.human "legacy_col_person_name", "Name"
        assert.deepEqual topic.humans, [["legacy_col_person_name", "Name"]]

      'plural': (topic) ->
        assert.isEmpty topic.plurals
        topic.plural 'ox', 'oxen'
        assert.deepEqual topic.plurals, [['ox', 'oxen']]
        topic.uncountable 'money'
        assert.deepEqual topic.uncountables, ['money']
        topic.uncountable 'monies'
        topic.plural 'money', 'monies'
        assert.deepEqual topic.plurals, [['money', 'monies'], ['ox', 'oxen']]
        assert.isEmpty topic.uncountables

      'singular': (topic) ->
        assert.isEmpty topic.singulars
        topic.singular 'ox', 'oxen'
        assert.deepEqual topic.singulars, [['ox', 'oxen']]
        topic.uncountable 'money'
        assert.deepEqual topic.uncountables, ['money']
        topic.uncountable 'monies'
        topic.singular 'money', 'monies'
        assert.deepEqual topic.singulars, [['money', 'monies'], ['ox', 'oxen']]
        assert.isEmpty topic.uncountables

      'irregular': (topic) ->
        topic.clear()
        topic.uncountable ['octopi', 'octopus']
        assert.deepEqual topic.uncountables, ['octopi', 'octopus']
        topic.irregular 'octopus', 'octopi'
        assert.isEmpty topic.uncountables
        assert.equal topic.singulars[0][0].toString(), /(o)ctopi$/i.toString()
        assert.equal topic.singulars[0][1], '$1ctopus'
        assert.equal topic.plurals[0][0].toString(), /(o)ctopi$/i.toString()
        assert.equal topic.plurals[0][1], '$1ctopi'
        assert.equal topic.plurals[1][0].toString(), /(o)ctopus$/i.toString()
        assert.equal topic.plurals[1][1].toString(), '$1ctopi'

      'pluralize':
        'empty': (topic) ->
          assert.equal topic.pluralize(''), ''

        'uncountable': (topic) ->
          assert.deepEqual topic.uncountables, ['money', 'rice']
          assert.equal topic.pluralize('money'), 'money'

        'normal': (topic) ->
          topic.irregular 'octopus', 'octopi'
          assert.equal topic.pluralize('octopus'), 'octopi'

      'singuralize':
        'empty': (topic) ->
          assert.equal topic.singularize(''), ''

        'uncountable': (topic) ->
          assert.deepEqual topic.uncountables, ['money', 'rice']
          assert.equal topic.singularize('money'), 'money'

        'normal': (topic) ->
          topic.irregular 'octopus', 'octopi'
          assert.equal topic.singularize('octopi'), 'octopus'

      'humanize':
        'normal': (topic) ->
          assert.equal topic.humanize('employee_salary'), 'Employee salary'

        'with _id': (topic) ->
          assert.equal topic.humanize('author_id'), 'Author'

      'titleize':
        'normal': (topic) ->
          assert.equal topic.titleize('man from the boondocks'), 'Man From The Boondocks'

        'with hyphens': (topic) ->
          assert.equal topic.titleize('x-men: the last stand'), 'X Men: The Last Stand'

      'tableize': (topic) ->
        topic.irregular 'octopus', 'octopi'
        assert.equal topic.tableize('RawScaledOctopus'), 'raw_scaled_octopi'

      'classify':
        'underscore': (topic) ->
          topic.irregular 'octopus', 'octopi'
          assert.equal topic.classify('egg_and_octopi'), 'EggAndOctopus'

        'normal': (topic) ->
          topic.irregular 'octopus', 'octopi'
          assert.equal topic.classify('octopi'), 'Octopus'

  .export(module)
