Rails.application.routes.draw do
  root 'home#index'

  devise_for :candidates, path: 'candidates'
  devise_for :employees, path: 'employees', controllers: { registrations: 'employees/registrations'}

  resources :enrollments

  resources :companies, only: %i[index new show edit update] do
    resources :jobs, only: %i[index new create show edit update] do
      member do
        post 'disable'
        post 'apply'
      end
    end
  end

  get 'role', to: 'home#role'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
