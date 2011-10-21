# Base64 provides utility methods for encoding and de-coding binary data
# using a base 64 representation. A base 64 representation of binary data
# consists entirely of printable US-ASCII characters.

module.exports =

  # Decodes a base 64 encoded string to its original representation.
  #
  #     BulletSupport.Base64.decode64 "T3JpZ2luYWwgdW5lbmNvZGVkIHN0cmluZw=="
  #     => "Original unencoded string"
  decode64: (data) ->
    new Buffer(data, 'base64')


  # Encodes a string to its base 64 representation.
  #
  #     BulletSupport.Base64.encode64 "Original unencoded string"
  #     => "T3JpZ2luYWwgdW5lbmNvZGVkIHN0cmluZw=="
  encode64: (data) ->
    if typeof data is 'string'
      new Buffer(data).toString('base64')
    else
      data.toString('base64')
