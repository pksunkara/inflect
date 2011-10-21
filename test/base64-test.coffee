vows = require('vows')
assert = require('assert')

base64 = require('../src/base64')

vows
  .describe('Module Base64')
  .addBatch
    'encoding':
      topic: base64

      'correctly': (topic) ->
        assert.equal topic.encode64('Original unencoded string'), 'T3JpZ2luYWwgdW5lbmNvZGVkIHN0cmluZw=='

    'decoding':
      topic: base64

      'correctly': (topic) ->
        assert.equal topic.decode64('T3JpZ2luYWwgdW5lbmNvZGVkIHN0cmluZw=='), 'Original unencoded string'

  .export(module)
