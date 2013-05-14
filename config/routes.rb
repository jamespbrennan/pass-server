require 'api_constraints'

PassServer::Application.routes.draw do

  constraints(:subdomain => /^(|www)$/) do
    get '/signup' => 'users#new', as: 'signup'
    get '/login' => 'sessions#new', as: 'login'
    get '/logout' => 'sessions#destroy', as: 'logout'

    resources :users
    patch 'users/update_password/:id' => 'users#update_password', as: 'update_password'

    resources :sessions
    post 'sessions/callback' => 'sessions#callback', as: 'callback'

    resources :devices
    get 'devices/logins/:id' => 'devices#logins', as: 'logins'

    resources :device_accounts

    get 'about' => 'about#index'
    
    get 'developers' => 'developers#index'
    get 'developers/api' => 'developers#api', as: 'api'

    resources :services

    root to: 'devices#index'
  end

  constraints :subdomain => 'api' do
    scope module: :api do

      scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
        # Give them a blank page as the default route so it doesn't look like the API is down
        root to: proc { [200, {}, ['']] }

        post 'sessions' => 'sessions#create'
        get 'sessions' => 'sessions#get'
        get 'sessions/authenticate' => 'sessions#authenticate'
        post 'sessions/authenticate' => 'sessions#do_authentication'
        get 'sessions/:id' => 'sessions#get'

        post 'devices' => 'devices#create'
        post 'devices/register' => 'devices#register'

        post 'users' => 'users#create'
        get 'users' => 'users#get'
        delete 'users' => 'users#destroy'

        get '*a' => 'errors#routing'
        post '*a' => 'errors#routing'
        delete '*a' => 'errors#routing'
        patch '*a' => 'errors#routing'
        put '*a' => 'errors#routing'
      end
      
    end
  end
end
