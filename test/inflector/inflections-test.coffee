vows = require 'vows'
assert = require 'assert'

require('../../src/core')

cases = require('./cases')
Inflections = require('../../src/inflector/inflections').Inflections

vows
  .describe('Module Inflector inflections')
  .addBatch
    'Test inflector inflections':
      topic: ->
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
          topic.clear()
          assert.isEmpty topic.uncountables
          topic.uncountable 'money'
          assert.deepEqual topic.uncountables, ['money']

        'many items': (topic) ->
          topic.clear()
          assert.isEmpty topic.uncountables
          topic.uncountable ['money', 'rice']
          assert.deepEqual topic.uncountables, ['money', 'rice']

      'human': (topic) ->
        topic.clear()
        assert.isEmpty topic.humans
        topic.human "legacy_col_person_name", "Name"
        assert.deepEqual topic.humans, [["legacy_col_person_name", "Name"]]

      'plural': (topic) ->
        topic.clear()
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
        topic.clear()
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

  .addBatch
    'Test inflector inflection methods':
      topic: ->
        new Inflections()

      'pluralize':
        'empty': (topic) ->
          assert.equal topic.pluralize(''), ''

        'uncountable': (topic) ->
          assert.equal topic.pluralize('money'), 'money'

        'normal': (topic) ->
          topic.irregular 'octopus', 'octopi'
          assert.equal topic.pluralize('octopus'), 'octopi'

        'cases': (topic) ->
          words = cases.SingularToPlural
          assert.equal topic.pluralize(i), words[i] for i in Object.keys words
          assert.equal topic.pluralize(i.capitalize()), words[i].capitalize() for i in Object.keys words

        'cases plural': (topic) ->
          words = cases.SingularToPlural
          assert.equal topic.pluralize(words[i]), words[i] for i in Object.keys words
          assert.equal topic.pluralize(words[i].capitalize()), words[i].capitalize() for i in Object.keys words

      'singuralize':
        'empty': (topic) ->
          assert.equal topic.singularize(''), ''

        'uncountable': (topic) ->
          assert.equal topic.singularize('money'), 'money'

        'normal': (topic) ->
          topic.irregular 'octopus', 'octopi'
          assert.equal topic.singularize('octopi'), 'octopus'

        'cases': (topic) ->
          words = cases.SingularToPlural
          assert.equal topic.singularize(words[i]), i for i in Object.keys words
          assert.equal topic.singularize(words[i].capitalize()), i.capitalize() for i in Object.keys words

      'uncountablility':
        'normal': (topic) ->
          words = topic.uncountables
          assert.equal topic.singularize(i), i for i in words
          assert.equal topic.pluralize(i), i for i in words
          assert.equal topic.singularize(i), topic.pluralize(i) for i in words

        'greedy': (topic) ->
          uncountable_word = "ors"
          countable_word = "sponsor"
          topic.uncountable uncountable_word
          assert.equal topic.singularize(uncountable_word), uncountable_word
          assert.equal topic.pluralize(uncountable_word), uncountable_word
          assert.equal topic.pluralize(uncountable_word), topic.singularize(uncountable_word)
          assert.equal topic.singularize(countable_word), 'sponsor'
          assert.equal topic.pluralize(countable_word), 'sponsors'
          assert.equal topic.singularize(topic.pluralize(countable_word)), 'sponsor'

      'humanize':
        'normal': (topic) ->
          words = cases.UnderscoreToHuman
          assert.equal topic.humanize(i), words[i] for i in Object.keys words

        'with rule': (topic) ->
          topic.human /^(.*)_cnt$/i, '$1_count'
          topic.human /^prefix_(.*)$/i, '$1'
          assert.equal topic.humanize('jargon_cnt'), 'Jargon count'
          assert.equal topic.humanize('prefix_request'), 'Request'

        'with string': (topic) ->
          topic.human 'col_rpted_bugs', 'Reported bugs'
          assert.equal topic.humanize('col_rpted_bugs'), 'Reported bugs'
          assert.equal topic.humanize('COL_rpted_bugs'), 'Col rpted bugs'

        'with _id': (topic) ->
          assert.equal topic.humanize('author_id'), 'Author'

      'titleize':
        'normal': (topic) ->
          words = cases.MixtureToTitleCase
          assert.equal topic.titleize(i), words[i] for i in Object.keys words

        'with hyphens': (topic) ->
          assert.equal topic.titleize('x-men: the last stand'), 'X Men: The Last Stand'

      'tableize': (topic) ->
        words = cases.ClassNameToTableName
        assert.equal topic.tableize(i), words[i] for i in Object.keys words

      'classify':
        'underscore': (topic) ->
          words = cases.ClassNameToTableName
          assert.equal topic.classify(words[i]), i for i in Object.keys words
          assert.equal topic.classify('table_prefix.'+words[i]), i for i in Object.keys words

        'normal': (topic) ->
          topic.irregular 'octopus', 'octopi'
          assert.equal topic.classify('octopi'), 'Octopus'

  .export(module)
