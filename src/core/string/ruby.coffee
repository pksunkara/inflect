# Some implementation of ruby string functions in js

module.exports = (klass) ->

  # Returns a copy of str with all occurrences of pattern replaced with either replacement or the return value of a function.
  # The pattern will typically be a Regexp; if it is a String then no regular expression metacharacters will be interpreted
  # (that is /\d/ will match a digit, but ’\d’ will match a backslash followed by a ‘d’).
  #
  # In the function form, the current match object is passed in as a parameter to the function, and variables such as
  # $[1], $[2], $[3] (where $ is the match object) will be set appropriately. The value returned by the function will be
  # substituted for the match on each call.
  #
  # The result inherits any tainting in the original string or any supplied replacement string.
  #
  #    "hello".gsub /[aeiou]/, '*'      #=> "h*ll*"
  #    "hello".gsub /[aeiou]/, ($) ->
  #       "<#{$[1]}>"                   #=> "h<e>ll<o>"
  #
  klass::gsub = (pattern, replacement) ->
    result = ''
    self = this

    unless pattern? and replacement?
      for key in self
        result += key
      return result

    while self.length > 0
      if (match = self.match(pattern))
        result += self.slice(0, match.index)
        if typeof replacement is 'function'
          match[1] = match[1] || match[0]
          result += replacement(match)
        else
          result += replacement
        self = self.slice(match.index + match[0].length)
      else
        result += self
        self = ''

    result

  # The first letter will be made upper case
  #
  #     "hello".upcase #=> "Hello"
  klass::upcase = ->
    result = ''
    self = this

    for key in self
        result += key
    result[0].toUpperCase() + result.substr(1)

  # The first letter will be made lower case
  #
  #     "HELLO".downcase #=> "hELLO"
  klass::downcase = ->
    result = ''
    self = this

    for key in self
      result += key
    result[0].toLowerCase() + result.substr(1)
