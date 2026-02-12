require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  root "lookups#index"
  resources :lookups, only: [:index, :create]

  get "up" => "rails/health#show", as: :rails_health_check
end
