module.exports = function(grunt) {
  // Project configuration.
  grunt.initConfig({
	log: {
	  foo: [1, 2, 3],
	  bar: 'hello world',
	  baz: false
	}
  });

  grunt.registerMultiTask('log', 'Log stuff.', function() {
	grunt.log.writeln(this.target + ': ' + this.data);
  });

  grunt.registerTask('default', ['log']);
};
