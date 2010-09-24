module Schedular
  class Time < ActiveRecord::Base
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
    
    named_scope :duration, lambda{ |duration| {:conditions => {:duration => duration}} }
    named_scope :duration_less_or_equal, lambda{ |duration| {:conditions => ['duration <= ?', duration]} }
    named_scope :duration_more_or_equal, lambda{ |duration| {:conditions => ['duration >= ?', duration]} }
    
    def self.by_params params
      return if params[:year].nil? and params[:month].nil? #TODO: By year
      day = Date.civil params[:year].to_i, params[:month].to_i, (params[:day] || 1).to_i
      params[:day] ? by_time_or_period(day) : by_time_or_period(day..day >> 1)
    end
  end
end