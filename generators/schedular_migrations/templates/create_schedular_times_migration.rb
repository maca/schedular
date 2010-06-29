class CreateSchedularTimes < ActiveRecord::Migration
  def self.up
    create_table :schedular_times do |t|
      t.datetime :value
      t.boolean  :all_day
      
      t.timestamps
    end
  end

  def self.down
    drop_table :schedular_times
  end
end