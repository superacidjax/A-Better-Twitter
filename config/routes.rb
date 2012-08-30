BetterTwitter::Application.routes.draw do

  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :notes, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :groups

  root to: 'pages#home'

  match '/signup', to: 'users#new'
  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy'

  match '/help', to: 'pages#help'
  match '/contact', to: 'pages#contact'
  match '/about', to: 'pages#about'


  match '/ui(/:action)', controller: 'ui'

end
