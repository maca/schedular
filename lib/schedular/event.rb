module Schedular
  class Event < ActiveRecord::Base
    extend ByParams
    
    set_table_name :schedular_events
    has_and_belongs_to_many :times, :join_table => :schedular_events_times, :class_name => 'Schedular::Time'
    
    validates_presence_of :name
    validate :times_not_empty
    
    named_scope :include_times,     :include => :times
    named_scope :by_time_or_period, lambda{ |time|
      time = Range === time || DateTime === time ? time : (time..time+1)
      {:conditions => {'schedular_times.value' => time}, :include => :times }
    }

    def dates= dates # TODO: This method is soooo uneficient
      parser = "#{ I18n.locale.to_s[0..1] }DatesParser".classify.constantize rescue raise("Eventual has not yet been implemented with for the locale '#{I18n.locale}'")
      parsed = parser.new.parse(dates)
      
      self.times = parsed.map do |time|
        all_day  = !(DateTime === time)
        Schedular::Time.all_day(all_day).by_time_or_period(time).first || Schedular::Time.new(:value => time, :all_day => all_day)
      end if parsed
      
      self['dates'] = dates
    end
    
    private
    def times_not_empty
      errors.add(:dates, I18n.t('activerecord.errors.messages.invalid')) if self.dates and self.times.empty?
    end
  end
end