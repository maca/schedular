class CreateSchedularEventsTimes < ActiveRecord::Migration
  def self.up
    create_table :schedular_events_times, :id => false do |t|
      t.integer  :time_id
      t.integer  :event_id
    end
  end

  def self.down
    drop_table :schedular_events
  end
end