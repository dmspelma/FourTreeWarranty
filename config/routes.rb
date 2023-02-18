Rails.application.routes.draw do
  root 'warranty#index'

  resources :warranty
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
