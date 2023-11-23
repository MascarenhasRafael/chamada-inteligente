Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'
end
