Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' }, except: %i[new edit] do
    resources :users do
      resources :auths, only: %i[index show destroy]
    end
  end

  root to: 'pages#home'

  devise_for :auths,
             controllers: {
               omniauth_callbacks: 'callbacks/omniauth', sessions: 'sessions'
             }
end
