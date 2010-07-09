require 'helper'

class Schedular::TimeTest < Test::Unit::TestCase
  context 'date parsing' do
    setup do 
      Schedular::Event.destroy_all
      Schedular::Time.destroy_all
      @time = Schedular::Time.new :value => Date.civil(2010), :all_day => true
    end
    subject { @time }

    should_have_and_belong_to_many :events
    
    context 'named scopes' do
      setup do
        @event  = Schedular::Event.create! :dates => '1 de enero 2010 a las 10:00', :name => 'Evento 1'
        @event2 = Schedular::Event.create! :dates => 'enero y febrero 2010',        :name => 'Evento 2'
      end

      should 'have 60 times' do
        assert_equal 60, Schedular::Time.count
      end

      should 'find by time or period (Range)' do
        assert_equal 32, Schedular::Time.by_time_or_period(Date.civil(2010)..Date.civil(2010, 2)).size
      end
      
      should 'find by time or period (Date)' do
        assert_equal 2, Schedular::Time.by_time_or_period(Date.civil(2010)).size
      end
      
      should 'find by time or period (DateTime)' do
        assert_equal 1, Schedular::Time.by_time_or_period(DateTime.civil(2010, 1, 1, 10)).size
      end
      
      should 'find by all day' do
        assert_equal 59, Schedular::Time.all_day(true).size
      end
      
      should 'find by not all day' do
        assert_equal 1, Schedular::Time.all_day(false).size
      end
      
      should 'find by params with month' do
        day = Date.civil(2010)
        assert_equal Schedular::Time.by_time_or_period(day..day >> 1), Schedular::Time.by_params(:year => '2010', :month => '1')
      end

      should 'find by params with day' do
        day = Date.civil(2010, 3, 2)
        assert_equal Schedular::Time.by_time_or_period(day..day + 1), Schedular::Time.by_params(:year => '2010', :month => '3', :day => '2')
      end
    end
  end
end
