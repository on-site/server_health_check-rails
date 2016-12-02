ServerHealthCheckRails::Engine.routes.draw do
  resources :health, only: [:index, :show]
end
