require 'eventual'
require 'table_builder'
require 'es-mx-locale'

$:.unshift(File.dirname(__FILE__)) unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "schedular/by_params"
require "schedular/time"
require "schedular/event"
require "schedular/events_controller"

# Load locale files
I18n.load_path += Dir.glob "#{ File.dirname(__FILE__) }/schedular/locale/*.yml"


# Load class openings
Dir.glob(Rails.root.join('engines', 'schedular', '**', '*.rb')).each { |f| require f }

