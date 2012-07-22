BetterTwitter::Application.routes.draw do

  resources :users

  root :to => 'pages#home'

  match '/help', to: 'pages#help'
  match '/contact', to: 'pages#contact'
  match '/about', to: 'pages#about'
  match '/signup', to: 'users#new'

  match '/ui(/:action)', controller: 'ui'

end
