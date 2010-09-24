ActiveRecord::Migration.verbose       = false
ActiveRecord::Base.establish_connection :adapter => "sqlite3", :database => ":memory:"

ActiveRecord::Schema.define :version => 1 do

  create_table  :schedular_events do |t|
    t.string    :name
    t.string    :dates
    t.text      :description
    t.timestamps
  end
  
  create_table :schedular_times do |t|
    t.datetime :value
    t.boolean  :all_day
    t.integer  :duration
  end
  
  create_table :schedular_events_times, :id => false do |t|
    t.integer  :time_id
    t.integer  :event_id
  end
end