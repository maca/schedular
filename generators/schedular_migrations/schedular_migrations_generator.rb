class SchedularMigrationsGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.migration_template 'schedular_migrations.rb', 'db/migrate', :migration_file_name => "schedular_migrations"
    end
  end
end