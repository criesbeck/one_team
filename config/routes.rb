Oneteam2::Application.routes.draw do

  get "reports/index"
  authenticated :user do
    root to: 'requests#index', as: :authenticated_root
  end
  
  devise_for :users

  devise_scope :user do
    root to: "devise/sessions#new"
  end

  resources :users
  resources :requests do
    resources :responses, only: [:create, :destroy] do
      resources :assignments, only: [:create, :destroy, :update]
    end
  end

  get '/my_requests'  => 'requests#my_requests',   :as => :my_requests 
  get '/dashboard'    => 'reports#index',          :as => :dashboard

end
