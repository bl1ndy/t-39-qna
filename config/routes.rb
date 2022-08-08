Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions do
    member { delete :destroy_file }

    resources :answers, shallow: true, only: %i[create update destroy] do
      member { post :best }
    end
  end
end
