require "server_health_check_rails/version"
require "server_health_check_rails/engine"

module ServerHealthCheckRails
  class << self
    def all_checks
      raise ArgumentError, "Please configure server_health_check-rails!" if @checks.nil?
      @checks.keys
    end

    def apply_checks(server_health_check, checks)
      raise ArgumentError, "Please configure server_health_check-rails!" if @checks.nil?

      @checks.each do |check|
        check.call(server_health_check)
      end
    end

    def check(name, &block)
      @checks ||= {}
      @checks[name] = block
    end

    def check_activerecord!
      check "activerecord" do |server_health_check|
        server_health_check.activerecord!
      end
    end

    def check_redis!(host: nil, port: 6379)
      check "redis" do |server_health_check|
        server_health_check.redis! host: nil, port: 6379
      end
    end

    def check_aws_s3!(bucket = nil)
      check "aws_s3" do |server_health_check|
        server_health_check.aws_s3! bucket
      end
    end

    def check_aws_creds!
      check "aws_creds" do |server_health_check|
        server_health_check.aws_creds!
      end
    end
  end
end
