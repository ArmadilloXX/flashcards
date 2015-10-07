Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  filter :locale

  root "main#welcome"

  scope module: "home" do
    resources :user_sessions, only: [:new, :create]
    resources :users, only: [:new, :create]
    get "login" => "user_sessions#new", :as => :login

    post "oauth/callback" => "oauths#callback"
    get "oauth/callback" => "oauths#callback"
    get "oauth/:provider" => "oauths#oauth", as: :auth_at_provider
  end

  scope module: "dashboard" do
    resources :user_sessions, only: :destroy
    resources :users, only: :destroy
    post "logout" => "user_sessions#destroy", :as => :logout
    
    get '/cards/search_photos', to: 'cards#search_photos', as: :search_photos
    get '/cards/show_flickr_search', to: 'cards#show_flickr_search', as: :show_flickr_search
    
    resources :cards
           

    resources :blocks do
      member do
        put "set_as_current"
        put "reset_as_current"
      end
    end

    put "review_card" => "trainer#review_card"
    get "trainer" => "trainer#index"

    get "profile/:id/edit" => "profile#edit", as: :edit_profile
    put "profile/:id" => "profile#update", as: :profile
  end
end
