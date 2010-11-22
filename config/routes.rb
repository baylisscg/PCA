PcaApp::Application.routes.draw do

  # The priority is based upon order of creation:
  # first created -> highest priority.

  root :to => "application#index"
  match 'search' => 'application#search'
  match 'find'   => 'application#find'

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

end
