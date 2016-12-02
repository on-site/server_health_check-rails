require "test_helper"

class HealthControllerTest < ActionDispatch::IntegrationTest
  include ServerHealthCheckRails::Engine.routes.url_helpers
  setup { @routes = ServerHealthCheckRails::Engine.routes }
  setup { ServerHealthCheckRails.instance_variable_set(:@checks, nil) }

  def test_server_check_with_no_checks_fails
    error = assert_raises ArgumentError do
      get health_index_url
    end

    assert_match(/Please configure server_health_check-rails/, error.message)
  end
end
