Rails.application.routes.draw do
  root "home#index"
  get 'home/index'

  devise_for :users, controllers: { registrations: 'registrations' }
  post 'guest_sign_in', to: 'users#guest_user'

  resources :users, only: [:show, :edit, :update] do
    member do
      get :favorites
      get :reviews
    end
  end

  get '/account' => 'users#account'

  resources :stores do
    collection do
      get 'search'
    end
    resource :like, only: [:create, :destroy]
    resources :reviews, only: [:new, :create, :edit, :update, :destroy]
  end
end
