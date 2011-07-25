
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

#require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec'
require 'rails/all'
require 'acts_as_role'
require 'roles_validator'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/models/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
end
