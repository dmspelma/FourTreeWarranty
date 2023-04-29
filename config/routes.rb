# frozen_string_literal: true

# require 'sidekiq/web' # Leaving in for when I want to configure sidekiq-ui on production

Rails.application.routes.draw do
  devise_for :users
  root 'warranty#index'

  resources :warranty

  # authenticate :user do # Leaving in for when I want to configure sidekiq-ui on production
  #   mount Sidekiq::Web => '/sidekiq'
  # end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
