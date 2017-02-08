Rails.application.routes.draw do
  root 'artists#index'
  resources :artists do
    resources :songs, only: [:index, :show, :new, :edit]
  end
  resources :songs
end
