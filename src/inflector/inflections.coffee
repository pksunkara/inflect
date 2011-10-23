# A singleton instance of this class is yielded by Inflector.inflections, which can then be used to specify additional
# inflection rules. Examples:
#
#     BulletSupport.Inflector.inflections ($) ->
#       $.plural /^(ox)$/i, '\1\2en'
#       $.singular /^(ox)en/i, '\1'
#     
#       $.irregular 'octopus', 'octopi'
#     
#       $.uncountable "equipment"
#
# New rules are added at the top. So in the example above, the irregular rule for octopus will now be the first of the
# pluralization and singularization rules that is runs. This guarantees that your rules run before any of the rules that may
# already have been loaded.

class Inflections

  constructor: ->
    [@plurals, @singulars, @uncountables, @humans] = [[], [], [], []]

  # Specifies a new pluralization rule and its replacement. The rule can either be a string or a regular expression.
  # The replacement should always be a string that may include references to the matched data from the rule.
  plural: (rule, replacement) ->
    @uncountables = @uncountables.del rule if typeof(rule) == 'string'
    @uncountables = @uncountables.del replacement
    @plurals.unshift [rule, replacement]

  # Specifies a new singularization rule and its replacement. The rule can either be a string or a regular expression.
  # The replacement should always be a string that may include references to the matched data from the rule.
  singular: (rule, replacement) ->
    @uncountables = @uncountables.del rule if typeof(rule) == 'string'
    @uncountables = @uncountables.del replacement
    @singulars.unshift [rule, replacement]

  # Specifies a new irregular that applies to both pluralization and singularization at the same time. This can only be used
  # for strings, not regular expressions. You simply pass the irregular in singular and plural form.
  #
  #     irregular 'octopus', 'octopi'
  #     irregular 'person', 'people'
  irregular: (singular, plural) ->
    @uncountables = @uncountables.del singular
    @uncountables = @uncountables.del plural
    if singular[0].toUpperCase() == plural[0].toUpperCase()
      @plural new RegExp("(#{singular[0]})#{singular[1..-1]}$", "i"), '$1' + plural[1..-1]
      @plural new RegExp("(#{plural[0]})#{plural[1..-1]}$", "i"), '$1' + plural[1..-1]
      @singular new RegExp("(#{plural[0]})#{plural[1..-1]}$", "i"), '$1' + singular[1..-1]
    else
      @plural new RegExp("#{singular[0].toUpperCase()}(?i)#{singular[1..-1]}$"), plural[0].toUpperCase() + plural[1..-1]
      @plural new RegExp("#{singular[0].toLowerCase()}(?i)#{singular[1..-1]}$"), plural[0].toLowerCase() + plural[1..-1]
      @plural new RegExp("#{plural[0].toUpperCase()}(?i)#{plural[1..-1]}$"), plural[0].toUpperCase() + plural[1..-1]
      @plural new RegExp("#{plural[0].toLowerCase()}(?i)#{plural[1..-1]}$"), plural[0].toLowerCase() + plural[1..-1]
      @singular new RegExp("#{plural[0].toUpperCase()}(?i)#{plural[1..-1]}$"), singular[0].toUpperCase() + singular[1..-1]
      @singular new RegExp("#{plural[0].toLowerCase()}(?i)#{plural[1..-1]}$"), singular[0].toLowerCase() + singular[1..-1]

  # Specifies a humanized form of a string by a regular expression rule or by a string mapping.
  # When using a regular expression based replacement, the normal humanize formatting is called after the replacement.
  # When a string is used, the human form should be specified as desired (example: 'The name', not 'the_name')
  #
  #     human /_cnt$/i, '$1_count'
  #     human "legacy_col_person_name", "Name"
  human: (rule, replacement) ->
    @humans.unshift [rule, replacement]

  # Add uncountable words that shouldn't be attempted inflected.
  #
  #     uncountable "money"
  #     uncountable ["money", "information"]
  uncountable: (words) ->
    @uncountables = @uncountables.concat words

  # Clears the loaded inflections within a given scope (default is _'all'_).
  # Give the scope as a symbol of the inflection type, the options are: _'plurals'_,
  # _'singulars'_, _'uncountables'_, _'humans'_.
  #
  #     clear 'all'
  #     clear 'plurals'
  clear: (scope = 'all') ->
    switch scope
     when 'all' then [@plurals, @singulars, @uncountables, @humans] = [[], [], [], []]
     else @[scope] = []

module.exports = Inflections
