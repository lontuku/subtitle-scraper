Rails.application.routes.draw do
  get 'home/index'
  resources :searches
  post 'hola', to: 'creador_api#hola'
  get 'adios', to: 'creador_api#adios'
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
