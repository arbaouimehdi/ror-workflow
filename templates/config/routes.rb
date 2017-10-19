Rails.application.routes.draw do

  # Home Page
  root to: 'home#index'

  # Devise
  devise_for :users

end
