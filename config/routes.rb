Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' }, except: %i[new edit] do
    resources :users
  end

  root to: 'pages#home'

  as :auth do
    get 'sign_in', to: 'sessions#new', as: :new_session
  end
  get 'sign_up', to: 'pages#sign_up'

  devise_for :auths,
             controllers: {
               omniauth_callbacks: 'callbacks/omniauth', sessions: 'sessions'
             }
end
