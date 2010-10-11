module Schedular
  module Routes
    def self.draw map
      map.daily_schedule    "/events/:year/:month/:day.:format", :controller => 'schedular/events', :requirements => {:year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/}
      map.monthly_schedule  "/events/:year/:month.:format",      :controller => 'schedular/events', :requirements => {:year => /\d{4}/, :month => /\d{1,2}/}
      map.resources         :events,                             :controller => 'schedular/events', :name_prefix => 'schedular_'
    end
  end
end
