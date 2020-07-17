Rails.application.routes.draw do
  # API
  namespace :api, defaults: { format: 'json' }, except: %i[new edit] do
    delete 'logout', to: '/devise/sessions#destroy'

    resources :users do
      resources :auths, only: %i[index show destroy]
    end
  end

  # Mount frontend
  root to: 'pages#home'

  # Authentication
  devise_for :auths,
             controllers: {
               omniauth_callbacks: 'omniauth'
             }
end
