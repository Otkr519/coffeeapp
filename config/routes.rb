Rails.application.routes.draw do
  get 'home/index'
  devise_for :users
  post 'guest_sign_in', to: 'users#guest_user'
  resources :users, only:[:show, :edit, :update]
  get '/account' => 'users#account'

    resources :stores

end
