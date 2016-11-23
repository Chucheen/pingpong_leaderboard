Rails.application.routes.draw do
  devise_for :users, :controllers => {registrations: :registrations}
  root to: "matches#index"
  get '/history', to: 'matches#history'
  get '/log',     to: 'matches#new'

  resources :matches
end
