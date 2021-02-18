Rails.application.routes.draw do
  root 'home#index'

  devise_for :employees, controllers: { registrations: 'registrations'}

  resources :companies, only: %i[new create show]

  get 'role', to: 'home#role'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
