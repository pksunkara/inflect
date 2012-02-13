(function() {
  var assert, vows;

  vows = require('vows');

  assert = require('assert');

  require('../../lib/utils/array');
  require('../../lib/utils/string');

  vows.describe('Module core extension String').addBatch({
    'Testing value': {
      topic: 'bullet',
      'join the keys': function(topic) {
        return assert.equal(topic.value(), 'bullet');
      }
    },
    'Testing gsub': {
      topic: 'bullet',
      'when no args': function(topic) {
        return assert.equal(topic.gsub(), 'bullet');
      },
      'when only 1 arg': function(topic) {
        return assert.equal(topic.gsub(/./), 'bullet');
      },
      'when given proper args': function(topic) {
        return assert.equal(topic.gsub(/[aeiou]/, '*'), 'b*ll*t');
      },
      'when replacement is a function': {
        'with many groups': function(topic) {
          var str;
          str = topic.gsub(/([aeiou])(.)/, function($) {
            return "<" + $[1] + ">" + $[2];
          });
          return assert.equal(str, 'b<u>ll<e>t');
        },
        'with no groups': function(topic) {
          var str;
          str = topic.gsub(/[aeiou]/, function($) {
            return "<" + $[1] + ">";
          });
          return assert.equal(str, 'b<u>ll<e>t');
        }
      },
      'when replacement is special': {
        'with many groups': function(topic) {
          return assert.equal(topic.gsub(/([aeiou])(.)/, '<$1>$2'), 'b<u>ll<e>t');
        },
        'with no groups': function(topic) {
          return assert.equal(topic.gsub(/[aeiou]/, '<$1>'), 'b<u>ll<e>t');
        }
      }
    },
    'Testing capitalize': {
      topic: 'employee salary',
      'normal': function(topic) {
        return assert.equal(topic.capitalize(), 'Employee Salary');
      }
    },
    'Testing upcase': {
      topic: 'bullet',
      'only first letter should be upcase': function(topic) {
        return assert.equal(topic.upcase(), 'Bullet');
      },
      'letter after underscore': function(topic) {
        return assert.equal('bullet_record'.upcase(), 'Bullet_Record');
      },
      'letter after slash': function(topic) {
        return assert.equal('bullet_record/errors'.upcase(), 'Bullet_Record/Errors');
      },
      'no letter after space': function(topic) {
        return assert.equal('employee salary'.upcase(), 'Employee salary');
      }
    },
    'Testing downcase': {
      topic: 'BULLET',
      'only first letter should be downcase': function(topic) {
        return assert.equal(topic.downcase(), 'bULLET');
      },
      'letter after underscore': function(topic) {
        return assert.equal('BULLET_RECORD'.downcase(), 'bULLET_rECORD');
      },
      'letter after slash': function(topic) {
        return assert.equal('BULLET_RECORD/ERRORS'.downcase(), 'bULLET_rECORD/eRRORS');
      }
    }
  })["export"](module);

}).call(this);
