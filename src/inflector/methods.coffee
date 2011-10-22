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
  # Examples:
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
    if first_letter_in_uppercase
      result.upcase()
    else
      result
