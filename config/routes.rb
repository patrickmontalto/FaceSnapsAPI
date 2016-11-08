require 'api_constraints'

Rails.application.routes.draw do
  mount SabisuRails::Engine => "/sabisu_rails"
  devise_for :users
  # Api definition
  namespace :api, defaults: { format: :json },
                  constraints: { subdomain: 'api' }, path: '/' do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      # List resources here
      resources :users, :only => [:show, :create, :update, :destroy] do
        member do
          get 'follows', to: "relationships#follows"
          get 'followed-by', to: "relationships#followed_by"
          get 'relationship', to: "relationships#status"
          post 'relationship', to: "relationships#manage"
        end
        resources :posts, :only => [:create, :update, :destroy]
      end
      get 'users/self/follows', to: "relationships#current_user_follows"
      get 'users/self/followed-by', to: "relationships#current_user_followed_by"
      get 'users/self/requested-by', to: "relationships#requested_by"
      resources :sessions, :only => [:create, :destroy]
      resources :posts, :only => [:show, :index]
    end
  end
end