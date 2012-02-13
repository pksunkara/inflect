// Some string utility functions in js

module.exports = function (klass) {

  // Returns a copy of str with all occurrences of pattern replaced with either replacement or the return value of a function.
  // The pattern will typically be a Regexp; if it is a String then no regular expression metacharacters will be interpreted
  // (that is /\d/ will match a digit, but ‘\d’ will match a backslash followed by a ‘d’).
  //
  // In the function form, the current match object is passed in as a parameter to the function, and variables such as
  // $[1], $[2], $[3] (where $ is the match object) will be set appropriately. The value returned by the function will be
  // substituted for the match on each call.
  //
  // The result inherits any tainting in the original string or any supplied replacement string.
  //
  //     "hello".gsub /[aeiou]/, '*'      #=> "h*ll*"
  //     "hello".gsub /[aeiou]/, '<$1>'   #=> "h<e>ll<o>"
  //     "hello".gsub /[aeiou]/, ($) {
  //       "<#{$[1]}>"                    #=> "h<e>ll<o>"
  //
  klass.prototype.gsub = function (pattern, replacement) {
    var i, match, matchCmpr, matchCmprPrev, replacementStr, result, self;
    if (!((pattern != null) && (replacement != null))) return this.value();
    result = '';
    self = this;
    while (self.length > 0) {
      if ((match = self.match(pattern))) {
        result += self.slice(0, match.index);
        if (typeof replacement === 'function') {
          match[1] = match[1] || match[0];
          result += replacement(match);
        } else if (replacement.match(/\$[1-9]/)) {
          matchCmprPrev = match;
          matchCmpr = match.del(void 0);
          while (matchCmpr !== matchCmprPrev) {
            matchCmprPrev = matchCmpr;
            matchCmpr = matchCmpr.del(void 0);
          }
          match[1] = match[1] || match[0];
          replacementStr = replacement;
          for (i = 1; i <= 9; i++) {
            if (matchCmpr[i]) {
              replacementStr = replacementStr.gsub(new RegExp("\\\$" + i), matchCmpr[i]);
            }
          }
          result += replacementStr;
        } else {
          result += replacement;
        }
        self = self.slice(match.index + match[0].length);
      } else {
        result += self;
        self = '';
      }
    }
    return result;
  }

  // Returns a copy of the String with the first letter being upper case
  //
  //     "hello".upcase #=> "Hello"
  klass.prototype.upcase = function() {
    var self = this
    .gsub(/_([a-z])/, function ($) {
      return "_" + $[1].toUpperCase();
    }).gsub(/\/([a-z])/, function ($) {
      return "/" + $[1].toUpperCase();
    });
    return self[0].toUpperCase() + self.substr(1);
  }

  // Returns a copy of capitalized string
  //
  //     "employee salary" #=> "Employee Salary"
  klass.prototype.capitalize = function (spaces) {
    var self = this.toLowerCase();
    if(!spaces) {
      self = self.gsub(/\s([a-z])/, function ($) {
        return " " + $[1].toUpperCase();
      });
    }
    return self[0].toUpperCase() + self.substr(1);
  }

  // Returns a copy of the String with the first letter being lower case
  //
  //     "HELLO".downcase #=> "hELLO"
  klass.prototype.downcase = function() {
    var self = this
    .gsub(/_([A-Z])/, function ($) {
      return "_" + $[1].toLowerCase();
    }).gsub(/\/([A-Z])/, function ($) {
      return "/" + $[1].toLowerCase();
    });
    return self[0].toLowerCase() + self.substr(1);
  }

  // Returns a string value for the String object
  //
  //     "hello".value() #=> "hello"
  klass.prototype.value = function () {
    return this.substr(0);
  }
}

// Extend String prototype
module.exports(String);
