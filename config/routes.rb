Rails.application.routes.draw do
  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'welcome#index'

  resources :customers, only: [:create, :index]
  # match "signup",   to: "customers#new",            via: :get
  # match "home",     to: "customers#home",           via: :get
  # match "addshoe",  to: "customers#addshoe",        via: :post
  # match "delshoe",  to: "customers#delshoe",        via: :delete
  # match "predict",  to: "customers#predict"
  
  # match "signin",   to: "sessions#signin",          via: :get
  # match "signin",   to: "sessions#signin_attempt",  via: :post
  # match "signout",  to: "sessions#signout"

  get     "signup",   to: "customers#new"
  get     "home",     to: "customers#home"
  post    "addshoe",  to: "customers#addshoe"
  delete  "delshoe",  to: "customers#delshoe"
  get     "predict",  to: "customers#predict"
  get     "index",    to: "customers#index"
  
  get   "signin",   to: "sessions#signin"
  post  "signin",   to: "sessions#signin_attempt"
  get   "signout",  to: "sessions#signout"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
