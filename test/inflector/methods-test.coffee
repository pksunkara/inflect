vows = require 'vows'
assert = require 'assert'

require('../../src/core')

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

        'from dasherize': (topic) ->
          words = cases.UnderscoresToDashes
          assert.equal topic.underscore(topic.dasherize(i)), i for i in Object.keys words

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

  .addBatch
    'Test inflector inflection methods':
      topic: ->
        Inflector = require '../../src/inflector/methods'
        Inflector.inflections.default()
        Inflector

      'pluralize':
        'empty': (topic) ->
          assert.equal topic.pluralize(''), ''

        'uncountable': (topic) ->
          assert.equal topic.pluralize('money'), 'money'

        'normal': (topic) ->
          topic.inflections.irregular 'octopus', 'octopi'
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
          topic.inflections.irregular 'octopus', 'octopi'
          assert.equal topic.singularize('octopi'), 'octopus'

        'cases': (topic) ->
          words = cases.SingularToPlural
          assert.equal topic.singularize(words[i]), i for i in Object.keys words
          assert.equal topic.singularize(words[i].capitalize()), i.capitalize() for i in Object.keys words

      'uncountablility':
        'normal': (topic) ->
          words = topic.inflections.uncountables
          assert.equal topic.singularize(i), i for i in words
          assert.equal topic.pluralize(i), i for i in words
          assert.equal topic.singularize(i), topic.pluralize(i) for i in words

        'greedy': (topic) ->
          uncountable_word = "ors"
          countable_word = "sponsor"
          topic.inflections.uncountable uncountable_word
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
          topic.inflections.human /^(.*)_cnt$/i, '$1_count'
          topic.inflections.human /^prefix_(.*)$/i, '$1'
          assert.equal topic.humanize('jargon_cnt'), 'Jargon count'
          assert.equal topic.humanize('prefix_request'), 'Request'

        'with string': (topic) ->
          topic.inflections.human 'col_rpted_bugs', 'Reported bugs'
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
          topic.inflections.irregular 'octopus', 'octopi'
          assert.equal topic.classify('octopi'), 'Octopus'

  .export(module)
