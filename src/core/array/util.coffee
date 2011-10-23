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

# Extend Array class
module.exports Array
