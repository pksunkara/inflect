// Some array utility functions in js

module.exports = function (klass) {

  // Returns a copy of the array with the value removed once
  //
  //     [1, 2, 3, 1].del 1 #=> [2, 3, 1]
  //     [1, 2, 3].del 4    #=> [1, 2, 3]
  klass.prototype.del = function (val) {
    var index = this.indexOf(val);
    if (index != -1) {
      if (index == 0) {
       return this.slice(1)
      } else {
        return this.slice(0, index).concat(this.slice(index+1));
      }
    } else {
      return this;
    }
  }

  // Returns the first element of the array
  //
  //     [1, 2, 3].first() #=> 1
  klass.prototype.first = function() {
    return this[0];
  }

  // Returns the last element of the array
  //
  //     [1, 2, 3].last()  #=> 3
  klass.prototype.last = function() {
    return this[this.length-1];
  }
}

// Extend Array class
module.exports(Array);
