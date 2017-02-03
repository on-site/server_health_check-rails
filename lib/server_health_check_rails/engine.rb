module ServerHealthCheckRails
  class Engine < ::Rails::Engine
    isolate_namespace ServerHealthCheckRails

    initializer 'server_health_check_rails.bypass_ssl_for_health_index_path' do |app|
      # Allow access to health_index_path via HTTP.
      app.config.ssl_options ||= {}
      app.config.ssl_options[:redirect] ||= {}
      original_exclude = app.config.ssl_options[:redirect][:exclude]
      app.config.ssl_options[:redirect][:exclude] = ->(request){
        ServerHealthCheckRails::Engine.routes.url_helpers.health_index_path == request.path ||
          (original_exclude && original_exclude.call(request))
      }
    end
  end
end
