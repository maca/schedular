require 'helper'

class Schedular::TimeTest < Test::Unit::TestCase
  context 'date parsing' do
    setup do 
      Schedular::Event.destroy_all
      Schedular::Time.destroy_all
      @time = Schedular::Time.new :value => Date.civil(2010), :all_day => true
    end
    subject { @time }

    should have_and_belong_to_many :events
    should validate_presence_of :value

    context 'named scopes' do
      setup do
        Schedular::Time.create!  :value => DateTime.civil(2010, 1, 1, 10), :duration => 60,  :all_day => false
        Schedular::Time.create!  :value => DateTime.civil(2010, 1, 1, 10), :duration => 120, :all_day => false
        Schedular::Event.create! :dates => 'enero y febrero 2010', :name => 'Evento 2'
      end

      should 'have 60 times' do
        assert_equal 61, Schedular::Time.count
      end

      should 'find by time or period (Range)' do
        assert_equal 33, Schedular::Time.by_time_or_period(Date.civil(2010)..Date.civil(2010, 2)).size
      end
      
      should 'find by time or period (Date)' do
        assert_equal 3, Schedular::Time.by_time_or_period(Date.civil(2010)).size
      end
      
      should 'find by time or period (DateTime)' do
        assert_equal 2, Schedular::Time.by_time_or_period(DateTime.civil(2010, 1, 1, 10)).size
      end
      
      should 'find by all day' do
        assert_equal 59, Schedular::Time.all_day(true).size
      end
      
      should 'find by not all day' do
        assert_equal 2, Schedular::Time.all_day(false).size
      end
      
      should 'find by duration' do
        assert_equal 1, Schedular::Time.duration(60).size
        assert_equal 1, Schedular::Time.duration(120).size
      end
      
      should 'find by duration less than' do
        assert_equal 2, Schedular::Time.duration_less_or_equal(120).size
        assert_equal 2, Schedular::Time.duration_less_or_equal(121).size
        assert_equal 1, Schedular::Time.duration_less_or_equal(60).size
        assert_equal 1, Schedular::Time.duration_less_or_equal(61).size
      end
      
      should 'find by duration more than' do
        assert_equal 2, Schedular::Time.duration_more_or_equal(59).size
        assert_equal 2, Schedular::Time.duration_more_or_equal(60).size
        assert_equal 1, Schedular::Time.duration_more_or_equal(119).size
        assert_equal 1, Schedular::Time.duration_more_or_equal(120).size
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
  
    should 'allways order by value' do
      Schedular::Time.destroy_all
      times = [Date.today << 1, Date.today, Date.today >> 1]
      times.sort_by{ rand }.each{ |t| Schedular::Time.create(:value => t) }
      assert_equal times.map(&:month), Schedular::Time.find(:all).map{ |d| d.value.month  }
    end
  end
end
