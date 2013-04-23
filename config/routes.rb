require 'api_constraints'

PassServer::Application.routes.draw do

  constraints(:subdomain => /^(|www)$/) do
    get '/signup' => 'users#new', as: 'signup'
    get '/login' => 'sessions#new', as: 'login'
    get '/logout' => 'sessions#destroy', as: 'logout'

    resources :users
    patch 'users/update_password/:id' => 'users#update_password'

    resources :sessions

    resources :devices
    get 'devices/logins/:id' => 'devices#logins', as: 'logins'

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

        post 'devices' => 'devices#create'
        post 'devices/register' => 'devices#register'

        post 'users' => 'users#create'

        get '*a' => 'errors#routing'
        post '*a' => 'errors#routing'
        delete '*a' => 'errors#routing'
        patch '*a' => 'errors#routing'
        put '*a' => 'errors#routing'
      end
      
    end
  end
end
