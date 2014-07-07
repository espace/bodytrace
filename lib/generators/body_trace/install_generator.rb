module BodyTrace
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)
    argument :measurement_model, type: :string, default: "BodytraceMeasurement"
    argument :device_model, type: :string, default: "Device"
    argument :user_model, type: :string, default: "User"

    def setup_routes
      route "resources :#{measurement_model.underscore.pluralize}, only: [:create]"
    end

    def setup_models
      template "bodytrace_measurement.rb.erb", "app/models/#{measurement_model.underscore}.rb"
      template "device.rb.erb", "app/models/#{device_model.underscore}.rb"    
    end

    def setup_controllers
      template "bodytrace_measurements_controller.rb.erb", "app/controllers/#{measurement_model.underscore.pluralize}_controller.rb"
    end

    def setup_migrations
      migration_template "migrations/create_bodytrace_measurements.rb.erb", "db/migrate/create_#{measurement_model.underscore.pluralize}.rb"
      migration_template "migrations/create_devices.rb.erb", "db/migrate/create_#{device_model.underscore.pluralize}.rb"    
    end

    def self.next_migration_number(path)
      sleep 1
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end
    
  end
end