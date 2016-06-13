Rails.application.routes.draw do


  # get 'activities/index'

  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

# API's for user's methods

  post '/sign_up' => "webservices/user_apis#sign_up"
  post '/sign_up/verify' => 'webservices/user_apis#otp_confirm'
  post '/otp_resend' => "webservices/user_apis#otp_resend"
  post '/social_login' => "webservices/user_apis#social_login"
  put '/user_update' => 'webservices/user_apis#update_user'
  post '/user_profile' => 'webservices/user_apis#profile_show'
  post '/sign_in' => "webservices/user_apis#sign_in"
  post '/sign_out' => "webservices/user_apis#sign_out"
  post '/forget_password' => "webservices/user_apis#forget_password"
  post '/change_password' => "webservices/user_apis#change_password"

  
# API's for request methods 
  
  post '/send_request' => "webservices/request_apis#send_request"
  post '/accept_request' => "webservices/request_apis#accept_request"
  post '/reject_request' => "webservices/request_apis#reject_request"
  post '/pending_request' => "webservices/request_apis#pending_request"
  post '/contact_list' => "webservices/request_apis#contact_list"

#API's for finding activities notification.

  get '/home' => "webservices/event_apis#home"
  post '/notification_list' => "webservices/event_apis#notification_list"
  post '/generate_qr' => "webservices/event_apis#generate_qr"
  post '/scan_qr' => "webservices/event_apis#scan_qr"
  get '/trending' => "webservices/event_apis#trending"
  post '/add_social_login' => "webservices/event_apis#add_social_login"



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
