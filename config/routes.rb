Rails.application.routes.draw do
  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'welcome#index'

  # resources :customers, only: [:create, :index]
  
  get   "signin",   to: "sessions#signin"
  post  "signin",   to: "sessions#signin_attempt"
  get   "signout",  to: "sessions#signout"

  get     "signup",   to: "customers#new"
  post    "signup",   to: "customers#create"
  get     "home",     to: "customers#home"
  post    "home",     to: "customers#addshoe"
  delete  "home",     to: "customers#delshoe"
  get     "predict",  to: "customers#predict"
  get     "index",    to: "customers#index"
  
  get     "td_start",     to: "test_drive#start"
  post    "td_start",     to: "test_drive#create"
  get     "td_addshoes",  to: "test_drive#addshoes"
  post    "td_addshoes",  to: "test_drive#addshoe"
  delete  "td_delshoes",  to: "test_drive#delshoe"
  get     "td_ask",       to: "test_drive#ask"
  get     "td_predict",   to: "test_drive#prediction"
  get     "td_solidify",  to: "test_drive#solidify"
  post    "td_solidify",  to: "test_drive#do_solidify"

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
