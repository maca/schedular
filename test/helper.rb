$LOAD_PATH.unshift "#{ File.dirname __FILE__ }/../lib"
$LOAD_PATH.unshift File.dirname(__FILE__)

require 'rails_app/config/environment'

require 'test/unit'
require 'shoulda'

require 'support/migrations'
require 'events'

class Test::Unit::TestCase
end

