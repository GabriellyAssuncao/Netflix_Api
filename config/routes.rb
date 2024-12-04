Rails.application.routes.draw do
  resources :movies, defaults: { format: :json }
  get 'load_movies', to: 'movies#load_movies'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
