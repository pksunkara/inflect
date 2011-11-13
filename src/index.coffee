# Copyright (c) 2011 Pavan Kumar Sunkara
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require('./core')

##Table of Contents
module.exports =

  # The [version](version.html) class gives bullet-support's version
  Version: require './version'

  # The [LogSubscriber](log_subscriber.html) class dispatches notifications to
  # a registered object based on its given namespace
  LogSubscriber: require './log_subscriber'

  # The [Base64](base64.html) class provides utility methods for encoding
  # and decoding binary data into base64 representation
  Base64: require './base64'

  # The [StringInquirer](string_inquirer.html) class gives you a prettier
  # way to test for equality
  StringInquirer: require './string_inquirer'

  # The [Inflector](inflector/methods.html) class
  Inflector: require './inflector/methods'
