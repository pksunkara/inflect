
describe('Array', function(){
  var inflect;

  // Force require to invalidate caching.
  require.config({
      urlArgs: "bust=" + (new Date()).getTime()
  });

  // Inject inflect
  before(function(done) {
    require(['../lib/inflect'], function(inflectLib) {
      inflect = inflectLib();
      done();
    });
  });

  describe('#pluralize()', function() {
    it('should return people when we pluralize person', function(){
      inflect.pluralize("person").should.equal("people");
    });
    it('should return planes when we pluralize plane', function(){
      inflect.pluralize("plane").should.equal("planes");
    });
  });
});