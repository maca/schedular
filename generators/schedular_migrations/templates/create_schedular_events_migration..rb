class CreateSchedularEvents < ActiveRecord::Migration
  def self.up
    create_table :schedular_events do |t|
      t.string   :name
      t.string   :dates
      t.text     :description
      
      t.timestamps
    end
  end

  def self.down
    drop_table :schedular_events
  end
end