module ServerHealthCheckRails
  class HealthCheck
    def initialize(*checks, logger: Rails.logger)
      @check = ServerHealthCheck.new(logger: logger)
      ServerHealthCheckRails.apply_checks(@check, checks)
    end

    def self.all
      new(*ServerHealthCheckRails.all_checks)
    end

    def http_status
      if @check.ok?
        200
      else
        500
      end
    end

    def to_h
      {
        status: @check.results
      }
    end
  end
end
