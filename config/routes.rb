require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.confirmed? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      delete :cancel_vote
    end
  end

  concern :commentable do
    resources :comments, shallow: true, only: %i[create]
  end

  use_doorkeeper

  root to: 'questions#index'

  get 'search', to: 'search#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  post 'users/confirm_email', to: 'users#confirm_email'

  resources :questions do
    concerns :votable, :commentable

    member do
      delete :destroy_file
      delete :destroy_link
    end

    resources :answers, shallow: true, only: %i[create update destroy] do
      concerns :votable, :commentable

      member do
        post :best
        delete :destroy_file
        delete :destroy_link
      end
    end

    resources :subscriptions, shallow: true, only: %i[create destroy]
  end

  resource :achievements, only: %i[show]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index] do
        get :me, on: :collection
      end

      resources :questions, except: %i[new edit] do
        resources :answers, except: %i[new edit]
      end
    end
  end
end
