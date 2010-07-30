module Schedular
  class Time < ActiveRecord::Base
    extend ByParams
    default_scope :order => 'value asc'
    
    set_table_name :schedular_times
    has_and_belongs_to_many :events, :join_table => :schedular_events_times, :class_name => 'Schedular::Event'
    
    named_scope :joins_events,   :joins   => :events
    named_scope :include_events, :include => :events
    named_scope :order_by_value, :order => 'value asc'
    
    named_scope :by_time_or_period, lambda{ |time|
      time = Range === time || DateTime === time ? time : (time..time+1)
      { :conditions => {:value => time} }
    }
    
    named_scope :all_day, lambda{ |bool| {:conditions => {'all_day' => (bool.nil? ? true : bool)} }}
  end
end