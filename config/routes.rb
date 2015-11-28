Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  filter :locale
  mount ApiFlashcards::Engine, at: "/api"
  mount SwaggerEngine::Engine, at: "/api/v1/docs"
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
    get 'batches/new', to: 'batches#new', as: 'new_batch'
    post 'batches/', to: 'batches#create', as: 'batches'
    post "pusher/auth"
    get "pusher/load"
    resources :user_sessions, only: :destroy
    resources :users, only: :destroy
    post "logout" => "user_sessions#destroy", :as => :logout

    get "/flickr_search/search",
      to: "flickr_search#search",
      as: :search
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
