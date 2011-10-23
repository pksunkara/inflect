# The Inflector transforms words from singular to plural, class names to table names, modularized class names to ones without,
# and class names to foreign keys. The default inflections for pluralization, singularization, and uncountable words are kept
# in inflections.coffee
#
# If you discover an incorrect inflection and require it for your application, you'll need
# to correct it yourself (explained below).

module.exports =

  # By default, _camelize_ converts strings to UpperCamelCase. If the argument to _camelize_
  # is set to `false` then _camelize_ produces lowerCamelCase.
  #
  # _camelize_ will also convert '/' to '::' which is useful for converting paths to namespaces.
  #
  #     "bullet_record".camelize               # => "BulletRecord"
  #     "bullet_record".camelize(false)        # => "bulletRecord"
  #     "bullet_record/errors".camelize        # => "BulletRecord::Errors"
  #     "bullet_record/errors".camelize(false) # => "bulletRecord::Errors"
  #
  # As a rule of thumb you can think of _camelize_ as the inverse of _underscore_,
  # though there are cases where that does not hold:
  #
  #     "SSLError".underscore.camelize # => "SslError"
  camelize: (lower_case_and_underscored_word, first_letter_in_uppercase = true) ->
    result = lower_case_and_underscored_word.gsub /\/(.?)/, ($) ->
      "::#{$[1].upcase()}"
    .gsub /(?:_)(.)/, ($) ->
      $[1].upcase()
    if first_letter_in_uppercase then result.upcase() else result

  # Makes an underscored, lowercase form from the expression in the string.
  #
  # Changes '::' to '/' to convert namespaces to paths.
  #
  #     "BulletRecord".underscore         # => "bullet_record"
  #     "BulletRecord::Errors".underscore # => "bullet_record/errors"
  #
  # As a rule of thumb you can think of +underscore+ as the inverse of +camelize+,
  # though there are cases where that does not hold:
  #
  #     "SSLError".underscore.camelize # => "SslError"
  underscore: (camel_cased_word) ->
    self = camel_cased_word.gsub /::/, '/'
    .gsub /([A-Z]+)([A-Z][a-z])/, "$1_$2"
    self = self.gsub /([a-z\d])([A-Z])/, "$1_$2"
    .gsub /-/, '_'
    self.downcase()

  # Replaces underscores with dashes in the string.
  #
  #     "puni_puni" # => "puni-puni"
  dasherize: (underscored_word) ->
    underscored_word.gsub /_/, '-'

  # Removes the module part from the expression in the string.
  #
  #     "BulletRecord.String.Inflections".demodulize # => "Inflections"
  #     "Inflections".demodulize                     # => "Inflections"
  demodulize: (class_name_in_module) ->
    class_name_in_module.gsub /^.*\./, ''

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
