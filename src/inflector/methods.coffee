# The Inflector transforms words from singular to plural, class names to table names, modularized class names to ones without,
# and class names to foreign keys. The default inflections for pluralization, singularization, and uncountable words are kept
# in inflections.coffee
#
# If you discover an incorrect inflection and require it for your application, you'll need
# to correct it yourself (explained below).

module.exports =

  # Import inflections instance
  inflections: require './inflections'

  # Gives easy access to add inflections to this class
  inflect: (inflections_function) ->
    inflections_function @inflections

  # By default, _camelize_ converts strings to UpperCamelCase. If the argument to _camelize_
  # is set to _false_ then _camelize_ produces lowerCamelCase.
  #
  # _camelize_ will also convert '/' to '.' which is useful for converting paths to namespaces.
  #
  #     "bullet_record".camelize()             # => "BulletRecord"
  #     "bullet_record".camelize(false)        # => "bulletRecord"
  #     "bullet_record/errors".camelize()      # => "BulletRecord.Errors"
  #     "bullet_record/errors".camelize(false) # => "bulletRecord.Errors"
  #
  # As a rule of thumb you can think of _camelize_ as the inverse of _underscore_,
  # though there are cases where that does not hold:
  #
  #     "SSLError".underscore.camelize # => "SslError"
  camelize: (lower_case_and_underscored_word, first_letter_in_uppercase = true) ->
    result = lower_case_and_underscored_word.gsub /\/(.?)/, ($) ->
      ".#{$[1].upcase()}"
    result = result.gsub /(?:_)(.)/, ($) ->
      $[1].upcase()
    if first_letter_in_uppercase then result.upcase() else result

  # Makes an underscored, lowercase form from the expression in the string.
  #
  # Changes '.' to '/' to convert namespaces to paths.
  #
  #     "BulletRecord".underscore()         # => "bullet_record"
  #     "BulletRecord.Errors".underscore()  # => "bullet_record/errors"
  #
  # As a rule of thumb you can think of +underscore+ as the inverse of +camelize+,
  # though there are cases where that does not hold:
  #
  #     "SSLError".underscore().camelize() # => "SslError"
  underscore: (camel_cased_word) ->
    self = camel_cased_word.gsub /\./, '/'
    self = self.gsub /([A-Z]+)([A-Z][a-z])/, "$1_$2"
    self = self.gsub /([a-z\d])([A-Z])/, "$1_$2"
    self = self.gsub /-/, '_'
    self.toLowerCase()

  # Replaces underscores with dashes in the string.
  #
  #     "puni_puni".dasherize()   # => "puni-puni"
  dasherize: (underscored_word) ->
    underscored_word.gsub /_/, '-'

  # Removes the module part from the expression in the string.
  #
  #     "BulletRecord.String.Inflections".demodulize() # => "Inflections"
  #     "Inflections".demodulize()                     # => "Inflections"
  demodulize: (class_name_in_module) ->
    class_name_in_module.gsub /^.*\./, ''

  # Creates a foreign key name from a class name.
  # _separate_class_name_and_id_with_underscore_ sets whether
  # the method should put '_' between the name and 'id'.
  #
  #     "Message".foreign_key()      # => "message_id"
  #     "Message".foreign_key(false) # => "messageid"
  #     "Admin::Post".foreign_key()  # => "post_id"
  foreign_key: (class_name, separate_class_name_and_id_with_underscore = true) ->
    @underscore(@demodulize(class_name)) + (if separate_class_name_and_id_with_underscore then "_id" else "id")

  # Turns a number into an ordinal string used to denote the position in an
  # ordered sequence such as 1st, 2nd, 3rd, 4th.
  #
  #     ordinalize(1)     # => "1st"
  #     ordinalize(2)     # => "2nd"
  #     ordinalize(1002)  # => "1002nd"
  #     ordinalize(1003)  # => "1003rd"
  #     ordinalize(-11)   # => "-11th"
  #     ordinalize(-1021) # => "-1021st"
  ordinalize: (number) ->
    number = parseInt number
    if Math.abs(number)%100 in [11, 12, 13]
      "#{number}th"
    else
      switch Math.abs(number)%10
        when 1 then "#{number}st"
        when 2 then "#{number}nd"
        when 3 then "#{number}rd"
        else "#{number}th"

  # Checks a given word for uncountability
  #
  #     "money".uncountability()     # => true
  #     "my money".uncountability()  # => true
  uncountability: (word) ->
    @inflections.uncountables.some (ele, ind, arr) ->
      word.match(new RegExp("(\\b|_)#{ele}$", 'i'))?

  # Returns the plural form of the word in the string.
  #
  #     "post".pluralize()             # => "posts"
  #     "octopus".pluralize()          # => "octopi"
  #     "sheep".pluralize()            # => "sheep"
  #     "words".pluralize()            # => "words"
  #     "CamelOctopus".pluralize()     # => "CamelOctopi"
  pluralize: (word) ->
      result = word
      if word=='' or @uncountability(word)
        result
      else
        for plural in @inflections.plurals
          result = result.gsub plural[0], plural[1]
          break if word.match(plural[0])?
        result

  # The reverse of _pluralize_, returns the singular form of a word in a string.
  #
  #     "posts".singularize()            # => "post"
  #     "octopi".singularize()           # => "octopus"
  #     "sheep".singularize()            # => "sheep"
  #     "word".singularize()             # => "word"
  #     "CamelOctopi".singularize()      # => "CamelOctopus"
  singularize: (word) ->
    result = word
    if word=='' or @uncountability(word)
      result
    else
      for singular in @inflections.singulars
        result = result.gsub singular[0], singular[1]
        break if word.match(singular[0])
      result

  # Capitalizes the first word and turns underscores into spaces and strips a
  # trailing "_id", if any. Like _titleize_, this is meant for creating pretty output.
  #
  #     "employee_salary".humanize()   # => "Employee salary"
  #     "author_id".humanize()         # => "Author"
  humanize: (lower_case_and_underscored_word) ->
      result = lower_case_and_underscored_word
      for human in @inflections.humans
        result = result.gsub human[0], human[1]
      result.gsub(/_id$/, "").gsub(/_/," ").capitalize(false)

  # Capitalizes all the words and replaces some characters in the string to create
  # a nicer looking title. _titleize_ is meant for creating pretty output. It is not
  # used in the Bullet internals.
  #
  #
  #     "man from the boondocks".titleize()   # => "Man From The Boondocks"
  #     "x-men: the last stand".titleize()    # => "X Men: The Last Stand"
  titleize: (word) ->
    self = @humanize @underscore(word)
    self = self.gsub /[^a-zA-Z:']/, ' '
    self.capitalize()

  # Create the name of a table like Bullet does for models to table names. This method
  # uses the _pluralize_ method on the last word in the string.
  #
  #     "RawScaledScorer".tableize()   # => "raw_scaled_scorers"
  #     "egg_and_ham".tableize()       # => "egg_and_hams"
  #     "fancyCategory".tableize()     # => "fancy_categories"
  tableize: (class_name) ->
    @pluralize @underscore(class_name)

  # Create a class name from a plural table name like Bullet does for table names to models.
  # Note that this returns a string and not a Class.
  #
  #     "egg_and_hams".classify()   # => "EggAndHam"
  #     "posts".classify()          # => "Post"
  #
  # Singular names are not handled correctly:
  #
  #     "business".classify()       # => "Busines"
  classify: (table_name) ->
    @camelize @singularize(table_name.gsub(/.*\./, ''))
