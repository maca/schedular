require 'helper'

class Schedular::EventTest < Test::Unit::TestCase
  context 'date parsing' do
    setup do
      Schedular::Event.destroy_all
      Schedular::Time.destroy_all
      @event = Schedular::Event.new :dates => 'enero 2010', :name => 'evento 1'
    end
    subject { @event }
    
    should_validate_presence_of :name
    # should_validate_presence_of :dates
    
    should 'not accept bad date' do
      event = Schedular::Event.new :dates => 'bad dates', :name => 'evento 1'
      assert_equal false, event.valid?
      assert_equal I18n.t('activerecord.errors.messages.invalid'), event.errors[:dates]
    end
    
    context 'times without time' do
      should 'have 31 times' do
        assert_equal 31, @event.times.size
      end
      
      should 'be all_day for all times' do
        assert_equal [true]*31, @event.times.map(&:all_day)
      end
      
      should 'save all times and use existing' do
        @event.save
        assert_equal 31, Schedular::Time.count
        @event2 = Schedular::Event.new :dates => 'enero 2010', :name => 'evento 1'
        @event2.save
        assert_equal 31, Schedular::Time.count
      end
    end

    context 'times with time' do
      setup { @event = Schedular::Event.new :dates => 'enero 2010 a las 13:00', :name => 'evento 1' }
      
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
        assert_equal 31, Schedular::Time.count
        @event2 = Schedular::Event.new :dates => 'enero 2010 a las 13:00', :name => 'evento 1'
        @event2.save
        assert_equal 31, Schedular::Time.count
      end
    end

    context 'named scopes' do
      setup do 
        @event  = Schedular::Event.create :dates => 'enero y febrero 2010', :name => 'evento 1'
        @event2 = Schedular::Event.create :dates => '2 de enero del 2010',  :name => 'evento 2'
        @event3 = Schedular::Event.create :dates => '2 de marzo del 2010',  :name => 'evento 3'
      end

      should 'have 60 times' do
        assert_equal 60, Schedular::Time.count
      end

      should 'find by month' do
        assert_equal [@event, @event2], Schedular::Event.by_time_or_period(Date.civil(2010)..Date.civil(2010, 2))
      end

      should 'find by day' do
        assert_equal [@event3], Schedular::Event.by_time_or_period(Date.civil(2010, 3, 2))
      end

      should 'find by params with month' do
        assert_equal [@event, @event2], Schedular::Event.by_params(:year => '2010', :month => '1')
      end

      should 'find by params with day' do
        assert_equal [@event3], Schedular::Event.by_params(:year => '2010', :month => '3', :day => '2')
      end

      # should 'find by params with no year' do
      #   assert_equal Schedular::Event.find(:all), Schedular::Event.by_params(:year => nil)
      # end
    end
  
    should 'allways order times by value' do
      Schedular::Time.destroy_all
      times        = [Date.today << 1, Date.today, Date.today >> 1]
      @event.times = times.sort_by{rand}.map{ |t| Schedular::Time.create(:value => t) }
      assert_equal times.map(&:month), @event.times.map{ |d| d.value.month  }
    end
  end
end
