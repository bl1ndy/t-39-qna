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

  root to: 'questions#index'

  devise_for :users

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
end
