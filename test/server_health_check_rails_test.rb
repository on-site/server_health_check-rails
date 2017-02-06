require "test_helper"

class ServerHealthCheckRailsTest < ActiveSupport::TestCase
  setup { ServerHealthCheckRails.instance_variable_set(:@checks, nil) }

  def test_redis_honors_cutom_redis_config
    mock = Minitest::Mock.new
    mock.expect(:redis!, nil, [{ host: "custom.host", port: 4242 }])
    ServerHealthCheckRails.check_redis!(host: "custom.host", port: 4242)
    ServerHealthCheckRails.apply_checks(mock, ["redis"])
    assert_mock(mock)
  end

  def test_aws_s3_honors_cutom_bucket
    mock = Minitest::Mock.new
    mock.expect(:aws_s3!, nil, ["custom.bucket"])
    ServerHealthCheckRails.check_aws_s3!("custom.bucket")
    ServerHealthCheckRails.apply_checks(mock, ["aws_s3"])
    assert_mock(mock)
  end
end
