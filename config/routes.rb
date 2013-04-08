require 'api_constraints'

PassServer::Application.routes.draw do

  constraints(:subdomain => /^(|www)$/) do
    get '/signup', to: 'users#new', as: 'signup'
    get '/login', to: 'sessions#new', as: 'login'
    get '/logout', to: 'sessions#destroy', as: 'logout'

    resources :users
    resources :sessions
    resources :devices

    root to: 'devices#index'
  end

  constraints :subdomain => 'api' do
    scope module: :api do

      scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
        # Give them a blank page as the default route so it doesn't look like the API is down
        root to: proc { [200, {}, ['']] }

        post 'sessions' => 'sessions#create'
        get 'sessions' => 'sessions#get'
        post 'sessions/authenticate' => 'sessions#authenticate'

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
