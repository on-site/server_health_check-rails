module ServerHealthCheckRails
  class HealthController < ServerHealthCheckRails::ApplicationController
    def index
      check = ServerHealthCheckRails::HealthCheck.all
      render status: check.http_status, json: check.to_h
    end
  end
end
