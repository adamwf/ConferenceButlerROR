Rails.application.routes.draw do


 # root to: "admin/dashboard#index"

  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

# API's for user's methods
  namespace :webservices do
    resources :user_apis do
      collection do
        post :sign_up
        post :sign_in
        post :attendee_sign_in
        post :forward_sign_in
        post :otp_confirm
        post :otp_resend 
        post :otp_verification
        post :social_login
        post :profile
        post :update_user       
        post :sign_out
        post :forget_password
        post :change_password
        post :change_email
        post :availability
        post :update_availability
        post :privacy_status
        post :get_privacy_status
        post :update_privacy_status
        post :get_reminder
        post :set_reminder
      end
    end
    resources :request_apis do
      collection do
        post :send_request
        post :accept_request
        post :reject_request
        post :pending_request
        post :contact_list 
      end
    end
    resources :event_apis do
      collection do
        get :home
        post :notification_list
        post :generate_qr
        post :scan_qr
        get :trending
        get :event_list
        post :add_social_login 
        post :profile_view 
      end
    end
  end
  # You can have the root of your site routed with "root"
  resources :messages  do
    collection do
      post :get_chats
      get :get_chat_list
      post :attach_image
      post :get_group_chat
      post :user_status_for_chat
      get  :get_user_status
      post :notify_user
      get :unread_messages
    end
  end

  resource  :groups ,except: [:destroy] do
    collection do
      post :group_list
      put :update
      post :mute_group
      post :search_group
      post :group_destroy
    end
  end
  # root 'welcome#index'
  namespace :forward_info do
    root :to => "home#index"
    get '/signup' => 'profiles#new'
    get '/login' => 'sessions#new'
    post '/login' => 'sessions#create'
    delete '/logout' => 'sessions#destroy'
    resources :events
    resources :home do 
      member do 
       post 'accept_invitation'
       post 'decline_invitation'
      end
    end
    resources :profiles
    # post 'home/accept/:id' => 'home#accept_invitation'
    # post 'home/decline/:id' => 'home#decline_invitation'
    get '/passwords/forget_password' => 'passwords#forget_password'
    post '/passwords/reset_password' => 'passwords#reset_password'#, via: [:get, :post]
    post 'passwords/change_password/:id' => 'passwords#change_password'
  end
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase
  namespace :handle_directory do
    root :to => "home#index"
    get '/signup' => 'profiles#new'
    get '/login' => 'sessions#new'
    post '/login' => 'sessions#create'
    delete '/logout' => 'sessions#destroy'
    resources :messages
    resources :home
    resources :profiles
    get '/passwords/forget_password' => 'passwords#forget_password'
    post '/passwords/reset_password' => 'passwords#reset_password'#, via: [:get, :post]
    post 'passwords/change_password/:id' => 'passwords#change_password'
  end
  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  namespace :attendee_central do
    root :to => "home#index"
    get '/signup' => 'profiles#new'
    get '/login' => 'sessions#new'
    post '/login' => 'sessions#create'
    delete '/logout' => 'sessions#destroy'
    resources :messages
    resources :home
    resources :profiles
    resources :events
    get '/passwords/forget_password' => 'passwords#forget_password'
    post '/passwords/reset_password' => 'passwords#reset_password'#, via: [:get, :post]
    post 'passwords/change_password/:id' => 'passwords#change_password'
  end
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
