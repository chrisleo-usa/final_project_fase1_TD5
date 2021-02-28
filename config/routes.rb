Rails.application.routes.draw do
  root 'home#index'

  devise_for :candidates, path: 'candidates', controllers: { registrations: 'candidates/registrations',
                                                            sessions: 'candidates/sessions' }

  devise_for :employees, path: 'employees', controllers: { registrations: 'employees/registrations', 
                                            sessions: 'employees/sessions' }

  resources :candidates, only: [:show] do
    resources :enrollments, only: [:index]
  end

  resources :enrollments, only: %i[show] do
    resources :proposals, only: %i[new create]
  end

  resources :companies, only: %i[index new show edit update destroy] do
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
