# Some implementation of ruby string functions in js

module.exports = (klass) ->

  # Returns a copy of str with all occurrences of pattern replaced with either replacement or the return value of a function.
  # The pattern will typically be a Regexp; if it is a String then no regular expression metacharacters will be interpreted
  # (that is /\d/ will match a digit, but ‘\d’ will match a backslash followed by a ‘d’).
  #
  # In the function form, the current match object is passed in as a parameter to the function, and variables such as
  # $[1], $[2], $[3] (where $ is the match object) will be set appropriately. The value returned by the function will be
  # substituted for the match on each call.
  #
  # The result inherits any tainting in the original string or any supplied replacement string.
  #
  #     "hello".gsub /[aeiou]/, '*'      #=> "h*ll*"
  #     "hello".gsub /[aeiou]/, ($) ->
  #       "<#{$[1]}>"                    #=> "h<e>ll<o>"
  #
  klass::gsub = (pattern, replacement) ->
    unless pattern? and replacement?
      return @value()

    result = ''
    self = this
    while self.length > 0
      if (match = self.match(pattern))
        result += self.slice(0, match.index)
        if typeof replacement is 'function'
          match[1] = match[1] or match[0]
          result += replacement(match)
        else
          result += replacement
        self = self.slice(match.index + match[0].length)
      else
        result += self
        self = ''
    result

  # Returns a copy of the String with the first letter being upper case
  #
  #     "hello".upcase #=> "Hello"
  klass::upcase = ->
    self = this
    .gsub /_([a-z])/, ($) ->
      "_#{$[1].toUpperCase()}"
    .gsub /\/([a-z])/, ($) ->
      "/#{$[1].toUpperCase()}"
    self[0].toUpperCase() + self.substr(1)

  # Returns a copy of the String with the first letter being lower case
  #
  #     "HELLO".downcase #=> "hELLO"
  klass::downcase = ->
    self = this
    .gsub /_([A-Z])/, ($) ->
      "_#{$[1].toLowerCase()}"
    .gsub /\/([A-Z])/, ($) ->
      "/#{$[1].toLowerCase()}"
    self[0].toLowerCase() + self.substr(1)

  # Returns a string value for the String object
  #
  #     "hello"._value() #=> "hello"
  klass::value = ->
    @substr(0)

# Extend String prototype
module.exports String
