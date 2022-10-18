Rails.application.routes.draw do
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
  end

  resource :achievements, only: %i[show]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index]
    end
  end
end
