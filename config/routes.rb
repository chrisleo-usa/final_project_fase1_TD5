Rails.application.routes.draw do
  root 'home#index'

  devise_for :employees, controllers: { registrations: 'employees/registrations'}

  resources :companies, only: %i[new show edit update]

  resources :jobs, only: %i[index new create show edit update]


  get 'role', to: 'home#role'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
