require 'open-uri'

#grab the latest java library and put it in extlib
jar_path = "extlib"
Dir.mkdir(jar_path) unless Dir.exist?(jar_path)
jar_filename = "ImageAnalysisTools.jar"
jar_url = "http://cloud.github.com/downloads/cjfuller/imageanalysistools/ImageAnalysisTools_5.1.1_standalone.jar"

File::open(File.expand_path(jar_filename, jar_path), 'wb') do |of|

  open(jar_url) do |f|
    of.write(f.read)
  end

end

Gem::Specification.new do |s|

  s.name        = 'rimageanalysistools'
  s.version     = '5.1.1'
  s.date        = '2012-10-17'
  s.summary     = "JRuby extensions to the ImageAnalysisTools java package"
  s.description = "Helper code and some extensions for the ImageAnalysisTools package at http://cjfuller.github.com/imageanalysistools/"
  s.authors     = ["Colin J. Fuller"]
  s.email       = 'cjfuller@gmail.com'
  s.homepage    = 'http://cjfuller.github.com/rimageanalysistools/'
  s.files       = Dir['lib/**/*.rb'] + Dir['extlib/**/*.jar']
  s.platform    = 'java'
  s.require_paths << 'extlib'
  s.license     = 'MIT'
  s.requirements = 'jruby'

end