Rails.application.routes.draw do
  devise_for :auths,
             controllers: {
               omniauth_callbacks: 'omniauth'
             }

  delete 'logout', to: '/devise/sessions#destroy'

  resources :users do
    resources :auths, only: %i[show index destroy]
  end
end
