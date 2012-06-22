# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "super_profile"
  s.version     = '0.0.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ben Mishkin"]
  s.email       = ["bmishkin@mac.com"]
  s.homepage    = "https://github.com/bmishkin/super_profile"
  s.summary     = %q{enhanced speed profile formatter for rspec and cucumber}
  s.description = %q{enhanced speed profile formatter for rspec and cucumber}

  # s.rubyforge_project = "super_profile"

  s.files =        Dir['lib/**/*.rb'] #+ Dir['bin/*']
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  # s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"] #, "lib/cucumber", 'lib/rspec']

  s.add_dependency('rspec-core', ["~> 2.0"])
  s.add_dependency('cucumber') # [">= ???]")
end