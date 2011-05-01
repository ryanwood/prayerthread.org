Prayerthread::Application.routes.draw do
  resources :announcements

  resources :prayers do
    member do
      get :answer
    end
    resources :comments
    resources :intercessions, :only => [:new, :create]
    resources :nudges, :only => [:new, :create]
  end

  resources :activities, :only => :index

  resources :groups do
    resources :memberships
    resources :invitations, :only => [:new, :create, :resend] do
      member do
        put :resend
      end
    end
  end

  match 'help' => 'help#index', :as => :help

  resources :invitations, :only => [:index, :destroy, :accept, :confirm, :ignore] do
    member do
      put :ignore
      get :confirm
      get :accept
    end
  end

  match 'account' => 'users#edit'
  match 'hide_announcements' => 'javascripts#hide_announcements'
  match 'show_announcements' => 'javascripts#show_announcements'

  # Clearance Overrides
  resource :session
  resources :users do
    resource :password, :to => 'clearance/passwords', :only => [:create, :edit, :update]
    resource :confirmation, :to => 'clearance/confirmations', :only => [:new, :create]
  end

  match 'sign_up' => 'users#new', :as => :sign_up
  match 'sign_in' => 'sessions#new', :as => :sign_in
  match 'sign_out' => 'sessions#destroy', :as => :sign_out, :method => :delete
  
  match 'mobile' => 'mobile#force_mobile_view'
  match 'standard' => 'mobile#force_standard_view'
  
  root :to => 'prayers#index'
  # match '/:controller(/:action(/:id))'
end
