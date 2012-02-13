// The Inflector transforms words from singular to plural, class names to table names, modularized class names to ones without,
// and class names to foreign keys. The default inflections for pluralization, singularization, and uncountable words are kept
// in inflections.coffee
//
// If you discover an incorrect inflection and require it for your application, you'll need
// to correct it yourself (explained below).

module.exports = {

  // Import [inflections](inflections.html) instance
  inflections: require('./inflections'),

  // Gives easy access to add inflections to this class
  inflect: function (inflections_function) {
    inflections_function(this.inflections);
  },

  // By default, _camelize_ converts strings to UpperCamelCase. If the argument to _camelize_
  // is set to _false_ then _camelize_ produces lowerCamelCase.
  //
  // _camelize_ will also convert '/' to '.' which is useful for converting paths to namespaces.
  //
  //     "bullet_record".camelize()             // => "BulletRecord"
  //     "bullet_record".camelize(false)        // => "bulletRecord"
  //     "bullet_record/errors".camelize()      // => "BulletRecord.Errors"
  //     "bullet_record/errors".camelize(false) // => "bulletRecord.Errors"
  //
  // As a rule of thumb you can think of _camelize_ as the inverse of _underscore_,
  // though there are cases where that does not hold:
  //
  //     "SSLError".underscore.camelize // => "SslError"
  camelize: function(lower_case_and_underscored_word, first_letter_in_uppercase) {
    var result;
    if (first_letter_in_uppercase == null) first_letter_in_uppercase = true;
    result = lower_case_and_underscored_word.gsub(/\/(.?)/, function($) {
      return "." + ($[1].upcase());
    });
    result = result.gsub(/(?:_)(.)/, function($) {
      return $[1].upcase();
    });
    if (first_letter_in_uppercase) {
      return result.upcase();
    } else {
      return result;
    }
  },

  // Makes an underscored, lowercase form from the expression in the string.
  //
  // Changes '.' to '/' to convert namespaces to paths.
  //
  //     "BulletRecord".underscore()         // => "bullet_record"
  //     "BulletRecord.Errors".underscore()  // => "bullet_record/errors"
  //
  // As a rule of thumb you can think of +underscore+ as the inverse of +camelize+,
  // though there are cases where that does not hold:
  //
  //     "SSLError".underscore().camelize() // => "SslError"
  underscore: function (camel_cased_word) {
    var self;
    self = camel_cased_word.gsub(/\./, '/');
    self = self.gsub(/([A-Z]+)([A-Z][a-z])/, "$1_$2");
    self = self.gsub(/([a-z\d])([A-Z])/, "$1_$2");
    self = self.gsub(/-/, '_');
    return self.toLowerCase();
  },

  // Replaces underscores with dashes in the string.
  //
  //     "puni_puni".dasherize()   // => "puni-puni"
  dasherize: function (underscored_word) {
    return underscored_word.gsub(/_/, '-');
  },

  // Removes the module part from the expression in the string.
  //
  //     "BulletRecord.String.Inflections".demodulize() // => "Inflections"
  //     "Inflections".demodulize()                     // => "Inflections"
  demodulize: function (class_name_in_module) {
    return class_name_in_module.gsub(/^.*\./, '');
  },

  // Creates a foreign key name from a class name.
  // _separate_class_name_and_id_with_underscore_ sets whether
  // the method should put '_' between the name and 'id'.
  //
  //     "Message".foreign_key()      // => "message_id"
  //     "Message".foreign_key(false) // => "messageid"
  //     "Admin::Post".foreign_key()  // => "post_id"
  foreign_key: function (class_name, separate_class_name_and_id_with_underscore) {
    if (separate_class_name_and_id_with_underscore == null) {
      separate_class_name_and_id_with_underscore = true;
    }
    return this.underscore(this.demodulize(class_name)) + (separate_class_name_and_id_with_underscore ? "_id" : "id");
  },

  // Turns a number into an ordinal string used to denote the position in an
  // ordered sequence such as 1st, 2nd, 3rd, 4th.
  //
  //     ordinalize(1)     // => "1st"
  //     ordinalize(2)     // => "2nd"
  //     ordinalize(1002)  // => "1002nd"
  //     ordinalize(1003)  // => "1003rd"
  //     ordinalize(-11)   // => "-11th"
  //     ordinalize(-1021) // => "-1021st"
  ordinalize: function (number) {
    var _ref;
    number = parseInt(number);
    if ((_ref = Math.abs(number) % 100) === 11 || _ref === 12 || _ref === 13) {
      return "" + number + "th";
    } else {
      switch (Math.abs(number) % 10) {
        case 1:
          return "" + number + "st";
        case 2:
          return "" + number + "nd";
        case 3:
          return "" + number + "rd";
        default:
          return "" + number + "th";
      }
    }
  },

  // Checks a given word for uncountability
  //
  //     "money".uncountability()     // => true
  //     "my money".uncountability()  // => true
  uncountability: function (word) {
    return this.inflections.uncountables.some(function(ele, ind, arr) {
      return word.match(new RegExp("(\\b|_)" + ele + "$", 'i')) != null;
    });
  },

  // Returns the plural form of the word in the string.
  //
  //     "post".pluralize()             // => "posts"
  //     "octopus".pluralize()          // => "octopi"
  //     "sheep".pluralize()            // => "sheep"
  //     "words".pluralize()            // => "words"
  //     "CamelOctopus".pluralize()     // => "CamelOctopi"
  pluralize: function (word) {
    var plural, result;
    result = word;
    if (word === '' || this.uncountability(word)) {
      return result;
    } else {
      for (var i = 0; i < this.inflections.plurals.length; i++) {
        plural = this.inflections.plurals[i];
        result = result.gsub(plural[0], plural[1]);
        if (word.match(plural[0]) != null) break;
      }
      return result;
    }
  },

  // The reverse of _pluralize_, returns the singular form of a word in a string.
  //
  //     "posts".singularize()            // => "post"
  //     "octopi".singularize()           // => "octopus"
  //     "sheep".singularize()            // => "sheep"
  //     "word".singularize()             // => "word"
  //     "CamelOctopi".singularize()      // => "CamelOctopus"
  singularize: function (word) {
    var result, singular;
    result = word;
    if (word === '' || this.uncountability(word)) {
      return result;
    } else {
      for (var i = 0; i < this.inflections.singulars.length; i++) {
        singular = this.inflections.singulars[i];
        result = result.gsub(singular[0], singular[1]);
        if (word.match(singular[0])) break;
      }
      return result;
    }
  },

  // Capitalizes the first word and turns underscores into spaces and strips a
  // trailing "_id", if any. Like _titleize_, this is meant for creating pretty output.
  //
  //     "employee_salary".humanize()   // => "Employee salary"
  //     "author_id".humanize()         // => "Author"
  humanize: function (lower_case_and_underscored_word) {
    var human, result;
    result = lower_case_and_underscored_word;
    for (var i = 0; i < this.inflections.humans.length; i++) {
      human = this.inflections.humans[i];
      result = result.gsub(human[0], human[1]);
    }
    return result.gsub(/_id$/, "").gsub(/_/, " ").capitalize(true);
  },

  // Capitalizes all the words and replaces some characters in the string to create
  // a nicer looking title. _titleize_ is meant for creating pretty output. It is not
  // used in the Bullet internals.
  //
  //
  //     "man from the boondocks".titleize()   // => "Man From The Boondocks"
  //     "x-men: the last stand".titleize()    // => "X Men: The Last Stand"
  titleize: function (word) {
    var self;
    self = this.humanize(this.underscore(word));
    self = self.gsub(/[^a-zA-Z:']/, ' ');
    return self.capitalize();
  },

  // Create the name of a table like Bullet does for models to table names. This method
  // uses the _pluralize_ method on the last word in the string.
  //
  //     "RawScaledScorer".tableize()   // => "raw_scaled_scorers"
  //     "egg_and_ham".tableize()       // => "egg_and_hams"
  //     "fancyCategory".tableize()     // => "fancy_categories"
  tableize: function (class_name) {
    return this.pluralize(this.underscore(class_name));
  },

  // Create a class name from a plural table name like Bullet does for table names to models.
  // Note that this returns a string and not a Class.
  //
  //     "egg_and_hams".classify()   // => "EggAndHam"
  //     "posts".classify()          // => "Post"
  //
  // Singular names are not handled correctly:
  //
  //     "business".classify()       // => "Busines"
  classify: function (table_name) {
    return this.camelize(this.singularize(table_name.gsub(/.*\./, '')));
  }
};
