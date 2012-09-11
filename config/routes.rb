BetterTwitter::Application.routes.draw do

require File.expand_path("../../lib/logged_in_constraint", __FILE__)

  resources :users do
    member do
      get :following, :followers, :memberships
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :notes, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :groups
  resources :memberships, only: [:create, :destroy]

  root to: 'users#new', constraints: LoggedInConstraint.new(false)
  root to: 'pages#home', constraints: LoggedInConstraint.new(true)

  match '/signup', to: 'users#new'
  match '/signin', to: 'sessions#new', as: 'signin'
  match '/signout', to: 'sessions#destroy'
  match '/welcome', to: 'pages#landing'

  match '/help', to: 'pages#help'
  match '/contact', to: 'pages#contact'
  match '/about', to: 'pages#about'


  match '/ui(/:action)', controller: 'ui'

end
