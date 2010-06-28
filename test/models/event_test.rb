require 'helper'

class Events::EventTest < Test::Unit::TestCase
  context 'date parsing' do
    setup do
      Events::Event.destroy_all
      Events::Time.destroy_all
      @event = Events::Event.new :dates => 'enero 2010', :name => 'evento 1'
    end
    subject { @event }

    should_have_and_belong_to_many :times
    # should_validate_presence_of :name

    context 'times without time' do
      should 'have 31 times' do
        assert_equal 31, @event.times.size
      end
      
      should 'be all_day for all times' do
        assert_equal [true]*31, @event.times.map(&:all_day)
      end
      
      should 'save all times and use existing' do
        @event.save
        assert_equal 31, Events::Time.count
        @event2 = Events::Event.new :dates => 'enero 2010', :name => 'evento 1'
        @event2.save
        assert_equal 31, Events::Time.count
      end
    end
    
    context 'times with time' do
      setup { @event = Events::Event.new :dates => 'enero 2010 a las 13:00', :name => 'evento 1' }
      
      should 'have 31 times' do
        assert_equal 31, @event.times.size
      end

      should 'not be all_day for all times' do
        assert_equal [false]*31, @event.times.map(&:all_day)
      end
      
      should 'map times' do
        assert_equal [13]*31, @event.times.map{ |d| d.value.hour }
      end
      
      should 'save all times and use existing' do
        @event.save
        assert_equal 31, Events::Time.count
        @event2 = Events::Event.new :dates => 'enero 2010 a las 13:00', :name => 'evento 1'
        @event2.save
        assert_equal 31, Events::Time.count
      end
    end
  
    context 'named scopes' do
      setup do 
        @event  = Events::Event.create :dates => 'enero y febrero 2010', :name => 'evento 1'
        @event2 = Events::Event.create :dates => '2 de enero del 2010',  :name => 'evento 2'
        @event3 = Events::Event.create :dates => '2 de marzo del 2010',  :name => 'evento 3'
      end

      should 'have 60 times' do
        assert_equal 60, Events::Time.count
      end

      should 'find by month' do
        assert_equal [@event, @event2], Events::Event.by_time_or_period(Date.civil(2010)..Date.civil(2010, 2))
      end
      
      should 'find by day' do
        assert_equal [@event3], Events::Event.by_time_or_period(Date.civil(2010, 3, 2))
      end
      
      should 'find by params with month' do
        assert_equal [@event, @event2], Events::Event.by_params(:year => '2010', :month => '1')
      end
      
      should 'find by params with day' do
        assert_equal [@event3], Events::Event.by_params(:year => '2010', :month => '3', :day => '2')
      end
      
      should 'find by params with no year' do
        assert_equal Events::Event.find(:all), Events::Event.by_params(:year => nil)
      end
    end
  end
end
