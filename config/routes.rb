Rails.application.routes.draw do
  root to: "books#index"

  # Sessions and Registrations (manual authentication)
  get '/sign_in', to: 'sessions#new', as: 'new_session'
  post '/sign_in', to: 'sessions#create', as: 'sessions'
  delete '/sign_out', to: 'sessions#destroy', as: 'destroy_session'

  get '/sign_up', to: 'registrations#new', as: 'new_registration'
  post '/sign_up', to: 'registrations#create', as: 'registrations'
  get '/edit_profile', to: 'registrations#edit', as: 'edit_registration'
  patch '/edit_profile', to: 'registrations#update'

  # Web routes for UI
  resources :books do
    resources :borrows, only: [:create]
  end
  resources :borrows, only: [:update]
  
  get '/dashboard', to: 'dashboards#show'
  get '/dashboards/librarian', to: 'dashboards#librarian', as: 'librarian_dashboard'
  get '/dashboards/member', to: 'dashboards#member', as: 'member_dashboard'

  # Authentication routes (custom)
  post '/auth/register', to: 'authentication#register'
  post '/auth/login', to: 'authentication#login'
  post '/auth/logout', to: 'authentication#logout'

  # API routes
  namespace :api do
    resources :books do
      collection do
        get :search
        get :available
      end
    end

    resources :borrows do
      collection do
        get :overdue
        get :due_today
      end
      member do
        patch :return_book
        put :return_book
      end
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
