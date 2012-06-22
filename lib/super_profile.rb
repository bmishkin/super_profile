
SHOW_TOP ||= (ENV['PROFILE_SHOW_TOP'] || -1).to_i # only show the x 
SHOW_ABOVE ||= (ENV['PROFILE_SHOW_MIN'] || 0.1).to_f # only show examples that take longer than x seconds

require 'cucumber/formatter/super_profile'
require 'rspec/super_profile'

require 'cucumber/cli/options'
Cucumber::Cli::Options::BUILTIN_FORMATS["SuperProfile"] = [
  "Cucumber::Formatter::SuperProfile",
  "Extended profile for Cucumber"
]