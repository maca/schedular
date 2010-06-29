require "#{ File.dirname(__FILE__) }/lib/route_tiny_cms.rb"

class SchedularMigrationsGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.migration_template 'create_schedular_times_migration.rb',        'db/migrate', :migration_file_name => "create_schedular_times"
      m.migration_template 'create_schedular_events_migration.rb',       'db/migrate', :migration_file_name => "create_schedular_events"
      m.migration_template 'create_schedular_events_times_migration.rb', 'db/migrate', :migration_file_name => "create_schedular_events_times"
    end
  end

end