require 'open-uri'

#grab the latest java library and put it in extlib

JAR_PATH = "extlib"
JAR_FILENAME = "ImageAnalysisTools.jar"
JAR_URL = "https://buildhive.cloudbees.com/job/cjfuller/job/imageanalysistools/lastSuccessfulBuild/artifact/target/imageanalysistools-5.1.3_dev-standalone.jar"

puts "downloading the current ImageAnalysisTools build from #{JAR_URL}"

Dir.mkdir(JAR_PATH) unless Dir.exist?(JAR_PATH)

File::open(File.expand_path(JAR_FILENAME, JAR_PATH), 'wb') do |of|

  open(JAR_URL) do |f|
    of.write(f.read)
  end

end


Gem::Specification.new do |s|

  s.name        = 'rimageanalysistools'
  s.version     = '5.1.2.1'
  s.date        = '2013-01-25'
  s.summary     = "JRuby extensions to the ImageAnalysisTools java package"
  s.description = "Helper code and some extensions for the ImageAnalysisTools package at http://cjfuller.github.com/imageanalysistools/"
  s.authors     = ["Colin J. Fuller"]
  s.email       = 'cjfuller@gmail.com'
  s.homepage    = 'https://github.com/cjfuller/rimageanalysistools/'
  s.files       = Dir["lib/**/*.rb"] + Dir["#{JAR_PATH}/**/*.jar"]
  s.platform    = 'java'
  s.require_paths << 'extlib'
  s.license     = 'MIT'
  s.requirements = 'jruby'

end
