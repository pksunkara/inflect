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

Inflector = require './methods'

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

  # Returns the plural form of the word in the string.
  #
  #     "post".pluralize             # => "posts"
  #     "octopus".pluralize          # => "octopi"
  #     "sheep".pluralize            # => "sheep"
  #     "words".pluralize            # => "words"
  #     "CamelOctopus".pluralize     # => "CamelOctopi"
  pluralize: (word) ->
      result = word
      if word=='' or @uncountables.indexOf(result.downcase())!=-1
        result
      else
        for plural in @plurals
          result = result.gsub plural[0], plural[1]
          break if result!=word
        result

  # The reverse of _pluralize_, returns the singular form of a word in a string.
  #
  #     "posts".singularize            # => "post"
  #     "octopi".singularize           # => "octopus"
  #     "sheep".singularize            # => "sheep"
  #     "word".singularize             # => "word"
  #     "CamelOctopi".singularize      # => "CamelOctopus"
  singularize: (word) ->
    result = word
    if word=='' or @uncountables.indexOf(result.downcase())!=-1
      result
    else
      for singular in @singulars
        result = result.gsub singular[0], singular[1]
        break if result!=word
      result

  # Capitalizes the first word and turns underscores into spaces and strips a
  # trailing "_id", if any. Like _titleize_, this is meant for creating pretty output.
  #
  #     "employee_salary" # => "Employee salary"
  #     "author_id"       # => "Author"
  humanize: (lower_case_and_underscored_word) ->
      result = lower_case_and_underscored_word
      for human in @humans
        result = result.gsub human[0], human[1]
      result.gsub(/_id$/, "").gsub(/_/," ").capitalize(false)

  # Capitalizes all the words and replaces some characters in the string to create
  # a nicer looking title. _titleize_ is meant for creating pretty output. It is not
  # used in the Bullet internals.
  #
  #
  #     "man from the boondocks".titleize # => "Man From The Boondocks"
  #     "x-men: the last stand".titleize  # => "X Men: The Last Stand"
  titleize: (word) ->
    self = @humanize(Inflector.underscore(word))
    self = self.gsub /[^a-zA-Z:']/, ' '
    self.capitalize()

  # Create the name of a table like Bullet does for models to table names. This method
  # uses the _pluralize_ method on the last word in the string.
  #
  #     "RawScaledScorer".tableize # => "raw_scaled_scorers"
  #     "egg_and_ham".tableize     # => "egg_and_hams"
  #     "fancyCategory".tableize   # => "fancy_categories"
  tableize: (class_name) ->
    @pluralize Inflector.underscore(class_name)

  # Create a class name from a plural table name like Bullet does for table names to models.
  # Note that this returns a string and not a Class.
  #
  #     "egg_and_hams".classify # => "EggAndHam"
  #     "posts".classify        # => "Post"
  #
  # Singular names are not handled correctly:
  #
  #     "business".classify     # => "Busines"
  classify: (table_name) ->
    Inflector.camelize @singularize(table_name.gsub(/.*\./, ''))

Inflector.Inflections = Inflections

module.exports = Inflector
