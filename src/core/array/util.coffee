# Some array utility functions in js

module.exports = (klass) ->

  # Returns a copy of the array with the value removed once
  #
  #     [1, 2, 3, 1].del 1 #=> [2, 3, 1]
  #     [1, 2, 3].del 4    #=> [1, 2, 3]
  klass::del = (val) ->
    index = @indexOf val
    if index != -1
      if index == 0 then @slice 1 else @slice(0, index).concat @slice(index+1)
    else
      this

  # Returns the first element of the array
  #
  #     [1, 2, 3].first() #=> 1
  klass::first = ->
    this[0]

  # Returns the last element of the array
  #
  #     [1, 2, 3].last()  #=> 3
  klass::last = ->
    this[@length-1]

# Extend Array class
module.exports Array
