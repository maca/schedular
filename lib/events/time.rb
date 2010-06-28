module Events
  class Time < ActiveRecord::Base
    set_table_name :events_times
    has_and_belongs_to_many :events, :join_table => :events_events_times, :class_name => 'Events::Event'
    
    named_scope :joins_events,   :joins   => :events
    named_scope :include_events, :include => :events
    
    named_scope :by_time_or_period, lambda{ |time|
      time = Range === time || DateTime === time ? time : (time..time+1)
      { :conditions => {:value => time} }
    }
    
    named_scope :all_day, lambda{ |bool| {:conditions => {'all_day' => (bool.nil? ? true : bool)} }}
  end
end