Rails.application.routes.draw do
  root 'home#index'

  devise_for :employees, controllers: { registrations: 'employees/registrations'}

  resources :companies, only: %i[index new show edit update] do
    resources :jobs, only: %i[index new create show edit update] do
      post 'disable', on: :member
    end
  end

  get 'role', to: 'home#role'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
