Rails.application.routes.draw do
  mount ServerHealthCheckRails::Engine, at: "/"
end
