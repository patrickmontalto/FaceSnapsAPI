require 'api_constraints'

Rails.application.routes.draw do
  # if Rails.env.development?
  #   mount SabisuRails::Engine => "/sabisu_rails"
  # end
  devise_for :users
  # Api definition
  namespace :api, defaults: { format: :json }, path: '/' do
                  #constraints: { subdomain: 'api' }, 
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      # List resources here
      resources :users, :only => [:show, :create, :update, :destroy] do
        member do
          get  'follows',      to: "relationships#follows"
          get  'followed-by',  to: "relationships#followed_by"
          get  'relationship', to: "relationships#status"
          post 'relationship', to: "relationships#manage"
          get  'posts/recent', to: "posts#user_recent"
        end
      end
      post   'users/sign_up', to: "registrations#create"
      get    'users/self', to: "users#self"
      post   'users/self/posts', to: "posts#create"
      put    'users/self/posts/:id', to: "posts#update"
      patch  'users/self/posts/:id', to: "posts#update"
      delete 'users/self/posts/:id', to: "posts#destroy"
      get    'users/self/posts/recent', to: "posts#current_user_recent"
      get    'users/self/follows', to: "relationships#current_user_follows"
      get    'users/self/followed-by', to: "relationships#current_user_followed_by"
      get    'users/self/requested-by', to: "relationships#requested_by"
      get    'users/self/posts/liked', to: "likes#liked_posts"
      get    'users/self/feed', to: "feed#show"
      get    'users/self/feed/post_ids', to: "feed#post_ids"
      get    'user/search', to: "users#search"
      get   'users/sign_up/check_availability', to: "registrations#check_availability"

      # Tags
      get 'tags/:tag_name', to: "tags#show"
      get 'tags/:tag_name/posts/recent', to: "tags#posts"
      get 'tags/search', to: "tags#search"
      
      # Locations
      get 'locations/:venue_id', to: 'locations#show'
      get 'locations/:venue_id/posts/recent', to: 'locations#posts'
      get 'locations/search', to: 'locations#search'

      resources :sessions, :only => [:create, :destroy]
      resources :posts, :only => [:show, :index] do
        member do
          resources :likes, :only => [:create]
          get 'likes', to: "likes#liking_users"
          delete 'likes', to: "likes#destroy"
        end
        resources :comments, :only => [:index, :create, :destroy]
      end
    end
  end
end