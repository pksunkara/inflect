# Wrapping a string in this class gives you a prettier way to test
# for equality. The value returned by `Bullet.env` is wrapped
# in a StringInquirer object so instead of calling this:
#
#     Bullet.env.value == "production"
#
# you can call this:
#
#     Bullet.env.production?  #=> true
#     Bullet.env.staging?     #=> false
#

class StringInquirer

  constructor: (env) ->
    @value = env
    @[env] = 'true'

module.exports = StringInquirer
