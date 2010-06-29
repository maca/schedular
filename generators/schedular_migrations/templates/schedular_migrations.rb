class SchedularMigrations < ActiveRecord::Migration
  def self.up
    create_table :schedular_events do |t|
      t.string   :name
      t.string   :dates
      t.text     :description
      t.timestamps
    end
    
    create_table :schedular_times do |t|
      t.datetime :value
      t.boolean  :all_day
      t.timestamps
    end
    
    create_table :schedular_events_times, :id => false do |t|
      t.integer  :time_id
      t.integer  :event_id
    end
  end

  def self.down
    drop_table :schedular_events
    drop_table :schedular_times
    drop_table :schedular_events_times
  end
end