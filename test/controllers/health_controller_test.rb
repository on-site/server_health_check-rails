require "test_helper"

class HealthControllerTest < ActionDispatch::IntegrationTest
  include ServerHealthCheckRails::Engine.routes.url_helpers
  setup { @routes = ServerHealthCheckRails::Engine.routes }
  setup { ServerHealthCheckRails.instance_variable_set(:@checks, nil) }

  def test_health_with_no_checks_fails
    error = assert_raises ArgumentError do
      get health_index_url
    end

    assert_match(/Please configure server_health_check-rails/, error.message)
  end

  def test_health_with_active_record_succeeds
    ServerHealthCheckRails.check_active_record!
    get health_index_url
    json = JSON.parse(@response.body)
    assert_equal status_hash(active_record: "OK"), json
  end

  def test_health_with_multiple_successful_checks
    ServerHealthCheckRails.check_active_record!
    ServerHealthCheckRails.check("foo") { true }
    get health_index_url
    json = JSON.parse(@response.body)
    assert_equal status_hash(active_record: "OK", foo: "OK"), json
  end

  def test_health_with_multiple_failed_checks
    ServerHealthCheckRails.check_active_record!
    ServerHealthCheckRails.check("foo") { false }
    ServerHealthCheckRails.check("bar") { false }
    get health_index_url
    json = JSON.parse(@response.body)
    assert_equal status_hash(active_record: "OK", foo: "Failed", bar: "Failed"), json
  end

  def test_health_with_multiple_error_checks
    ServerHealthCheckRails.check_active_record!
    ServerHealthCheckRails.check("foo") { raise "This is the first error" }
    ServerHealthCheckRails.check("bar") { raise "This is the second error" }
    get health_index_url
    json = JSON.parse(@response.body)
    assert_equal status_hash(active_record: "OK", foo: "This is the first error", bar: "This is the second error"), json
  end

  def test_health_with_mixed_error_and_failure_checks
    ServerHealthCheckRails.check_active_record!
    ServerHealthCheckRails.check("foo") { false }
    ServerHealthCheckRails.check("bar") { raise "This is the second error" }
    get health_index_url
    json = JSON.parse(@response.body)
    assert_equal status_hash(active_record: "OK", foo: "Failed", bar: "This is the second error"), json
  end

  def test_single_health_returns_just_the_requested_check
    ServerHealthCheckRails.check_active_record!
    ServerHealthCheckRails.check("foo") { true }
    ServerHealthCheckRails.check("bar") { true }
    get health_url("foo")
    json = JSON.parse(@response.body)
    assert_equal status_hash(foo: "OK"), json
  end

  def test_single_health_doesnt_invoke_non_requested_checks
    bar_called = false
    ServerHealthCheckRails.check_active_record!
    ServerHealthCheckRails.check("foo") { true }
    ServerHealthCheckRails.check("bar") { bar_called = true }
    get health_url("foo")
    json = JSON.parse(@response.body)
    assert_equal status_hash(foo: "OK"), json
    refute bar_called
  end

  private

  def status_hash(expected)
    { "status" => expected.stringify_keys }
  end
end
