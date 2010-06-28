ActionController::Routing::Routes.draw do |map|
  map.daily_schedule    "/events/:year/:month/:day.:format", :controller => 'events/events', :requirements => {:year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/}
  map.monthly_schedule  "/events/:year/:month.:format",      :controller => 'events/events', :requirements => {:year => /\d{4}/, :month => /\d{1,2}/}
  map.resources         :events,                             :controller => 'events/events', :name_prefix => 'events_'

end