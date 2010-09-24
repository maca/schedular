module Schedular
  class Event < ActiveRecord::Base
    set_table_name :schedular_events
    has_and_belongs_to_many :times, :join_table => :schedular_events_times, :class_name => 'Schedular::Time'#, :order => 'value asc'
    
    validates_presence_of :name, :dates
    validate :times_not_empty
    
    named_scope :all, {}
    named_scope :include_times,     :include => :times
    named_scope :by_time_or_period, lambda { |time|
      time = Range === time || DateTime === time ? time : (time..time+1)
      {:conditions => {'schedular_times.value' => time}, :include => :times }
    }

    def dates= dates
      parsed = Eventual.parse dates, :lang => I18n.locale
      
      if parsed
        self.times = parsed.map do |time|
          all_day  = time.class == Date
          
          if Range === time
            duration = ((time.last.to_f - time.first.to_f) / 60).to_i
            time     = time.first
          else
            duration = nil
          end
          # TODO: This method is soooo uneficient
          Schedular::Time.by_time_or_period(time).all_day(all_day).duration(duration).first || Schedular::Time.new(:value => time, :all_day => all_day, :duration => duration)
        end
      else
        self.times = []
      end
      
      self['dates'] = dates
    end
    
    def self.by_params params
      return all unless params[:year] and params[:month] #TODO: Find by year
      day = Date.civil params[:year].to_i, params[:month].to_i, (params[:day] || 1).to_i
      params[:day] ? by_time_or_period(day) : by_time_or_period(day..day >> 1)
    end
    
    private
    def times_not_empty
      errors.add(:dates, I18n.t('activerecord.errors.messages.invalid')) if self.dates and self.times.empty?
    end
  end
end