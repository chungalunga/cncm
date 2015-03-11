Rails.application.routes.draw do
  get '/idents/update_ident_priority' => 'idents#update_ident_priority'
  get '/idents/reject_proposed_time_slot' => 'idents#reject_proposed_time_slot'
	get '/idents/filter_calendar' => 'idents#filter_calendar'
	get '/idents/filter_calendar_category' => 'idents#filter_calendar_category'
  get '/idents/show_ident_card' => 'idents#show_ident_card'
  get '/idents/task_percentage_complete' => 'idents#task_percentage_complete'
  get '/idents/render_json' => 'idents#render_json'
	get '/' => 'pages#home'
	resources :idents
	resources :projects
	get 'projects/:id/delete' => 'projects#delete', :as => :projects_delete
	# The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
