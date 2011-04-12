PcaApp::Application.routes.draw do

  resources :authentications

  # The priority is based upon order of creation:
  # first created -> highest priority.

  root :to => "application#index"
  match 'search' => 'application#search'
  match 'find'   => 'application#find'

  match '/auth/:provider/callback' => 'authentications#create'
  
  resources :authentications, :only => [:index, :create]

  resources :connections do
    member do
      get  :events
      post :add_cert
      post :add_event
    end
  end

  resources :certs do
    member do
      get :connections
      get :events
    end
  end

  resources :events

  resources :users

end
