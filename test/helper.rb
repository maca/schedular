$LOAD_PATH.unshift "#{ File.dirname __FILE__ }/../lib"
$LOAD_PATH.unshift File.dirname(__FILE__)

require 'rails_app/config/environment'
require 'action_view/test_case'

require 'test/unit'
require 'shoulda'

require 'support/migrations'
require 'schedular'

class Test::Unit::TestCase
end

