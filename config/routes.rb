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
  
  resources :connections do
    member do
      get  :events
      post :add_cert
      post :add_event
    end
  end

  resources :certs
  resources :events
  resources :users

end
