module ServerHealthCheckRails
  class Engine < ::Rails::Engine
    isolate_namespace ServerHealthCheckRails

    initializer "ServerHealthCheckRails.add_middleware" do |app|
      app.middleware.unshift ServerHealthCheckRack::Middleware
    end
  end
end
