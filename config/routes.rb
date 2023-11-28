Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get '/test_api', to: 'test#test_api'

  resources :slots do
    collection do
      delete 'destroy_map'
      get 'show_nearest'
    end
  end

  resources :tickets
  
end
