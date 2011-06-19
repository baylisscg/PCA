#
#
#

PcaApp::Application.routes.draw do

  # The priority is based upon order of creation:
  # first created -> highest priority.

  root  :to      => "main#index"
  match "search" => "main#search"
  match "login"  => "main#login"

  match "/auth/:provider/callback" => "users#auth"

  resources :certs, :credentials, :events, :users

  resources :credentials do
    member do
      get :events
    end
  end

  resources :connections do
    member do
      get  :events
      post :add_cred
      post :add_event
    end
  end

  resources :subscriptions do
    collection do
      post 'endpoint'
    end
  end

end
