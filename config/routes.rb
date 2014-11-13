Passty::Application.routes.draw do
  resources :applications do
    resources :passwords
  end

  resource :migrate

  devise_for :users

  root 'applications#index'
end
