# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'server_health_check_rails/version'

Gem::Specification.new do |spec|
  spec.name          = "server_health_check-rails"
  spec.version       = ServerHealthCheckRails::VERSION
  spec.authors       = ["Mike Virata-Stone"]
  spec.email         = ["mjstone@on-site.com"]

  spec.summary       = %q{Healthcheck for Rails apps.}
  spec.description   = %q{Health check for Rails apps checking things like active record, redis, and AWS.}
  spec.homepage      = "https://github.com/on-site/server_health_check-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").select do |f|
    f.match(/^(app|config|lib|exe|CODE_OF_CONDUCT|LICENSE)/)
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rails", ">= 3.0", "< 7.0"
  spec.add_runtime_dependency "server_health_check", "~> 1.0", ">= 1.0.1"

  spec.add_development_dependency "bundler", ">= 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
