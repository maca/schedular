require 'helper'

class Events::TimeTest < Test::Unit::TestCase
  context 'date parsing' do
    setup do 
      Events::Event.destroy_all
      Events::Time.destroy_all
      @time = Events::Time.new :value => Date.civil(2010), :all_day => true
    end
    subject { @time }

    should_have_and_belong_to_many :events
    
    context 'named scopes' do
      setup do
        @event  = Events::Event.create! :dates => '1 de enero 2010 a las 10:00', :name => 'Evento 1'
        @event2 = Events::Event.create! :dates => 'enero y febrero 2010',        :name => 'Evento 2'
      end

      should 'have 60 times' do
        assert_equal 60, Events::Time.count
      end

      should 'find by time or period (Range)' do
        assert_equal 32, Events::Time.by_time_or_period(Date.civil(2010)..Date.civil(2010, 2)).size
      end
      
      should 'find by time or period (Date)' do
        assert_equal 2, Events::Time.by_time_or_period(Date.civil(2010)).size
      end
      
      should 'find by time or period (DateTime)' do
        assert_equal 1, Events::Time.by_time_or_period(DateTime.civil(2010, 1, 1, 10)).size
      end
      
      should 'find by all day' do
        assert_equal 59, Events::Time.all_day(true).size
      end
      
      should 'find by not all day' do
        assert_equal 1, Events::Time.all_day(false).size
      end
    end
  end
end
