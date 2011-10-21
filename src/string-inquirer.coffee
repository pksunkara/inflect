# Wrapping a string in this class gives you a prettier way to test
# for equality. The value returned by `Bullet.env` is wrapped
# in a StringInquirer object so instead of calling this:
#
#     Bullet.env == "production"
#
# you can call this:
#
#     Bullet.env.$ 'production'
#

class StringInquirer

  constructor: (str) ->
    @val = str

  $: (mode) ->
    @val == mode

module.exports = StringInquirer
