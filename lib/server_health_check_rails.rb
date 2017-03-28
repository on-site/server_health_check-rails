require "server_health_check/rack"
require "server_health_check_rails/version"
require "server_health_check_rails/engine"

module ServerHealthCheckRails
  class << self
    def method_missing(method, *args, &block)
      ServerHealthCheckRack::Checks.send(method, *args, &block)
    end

    def respond_to_missing?(method, include_private = false)
      ServerHealthCheckRack::Checks.respond_to?(method)
    end
  end

  class Config
    class << self
      def method_missing(method, *args, &block)
        ServerHealthCheckRack::Config.send(method, *args, &block)
      end

      def respond_to_missing?(method, include_private = false)
        ServerHealthCheckRack::Config.respond_to?(method)
      end
    end
  end
end
