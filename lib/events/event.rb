module Events
  class Event < ActiveRecord::Base
    set_table_name :events_events
    has_and_belongs_to_many :times, :join_table => :events_events_times, :class_name => 'Events::Time'

    validates_presence_of :name
    
    named_scope :include_times,     :include => :times
    named_scope :by_time_or_period, lambda{ |time|
      time = Range === time || DateTime === time ? time : (time..time+1)
      {:conditions => {'events_times.value' => time}, :include => :times }
    }
    
    def self.by_params params
      return include_times unless params[:year]
      day = Date.civil params[:year].to_i, params[:month].to_i, (params[:day] || 1).to_i
      params[:day] ? by_time_or_period(day) : by_time_or_period(day..day >> 1)
    end

    def dates= dates
      self.times = "#{ I18n.locale.to_s }DatesParser".classify.constantize.new.parse(dates).map do |time|
        all_day  = !(DateTime === time)
        Events::Time.all_day(all_day).by_time_or_period(time).first || Events::Time.new(:value => time, :all_day => all_day)
      end
      self['dates'] = dates
    end
  end
end