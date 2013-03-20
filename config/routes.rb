require 'api_constraints'

PassServer::Application.routes.draw do

  scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
    constraints :subdomain => 'api' do

      # Give them a blank page as the default route so it doesn't look like the API is down
      root to: proc { [200, {}, ['']] }

      post 'sessions/create' => 'sessions#create'
      get 'sessions/get' => 'sessions#get'
      post 'sessions/authenticate' => 'sessions#authenticate'

      post 'devices/create' => 'devices#create'
      post 'devices/register' => 'devices#register'

      post 'users/create' => 'users#create'
    end
  end

  constraints :subdomain => '' do
    root to: 'devices#index'

    get 'signup', to: 'users#new', as: 'signup'
    get 'login', to: 'sessions#new', as: 'login'
    get 'logout', to: 'sessions#destroy', as: 'logout'

    resources :users
    resources :sessions
    resources :devices
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root to: 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
