Rails.application.routes.draw do
  def api_resources(res, *args, &block)
    defaults = {
      format: :json,
      only: %i[index show create update destroy]
    }
    # this will be changed in Rails 6.1
    if args.length.positive? && args.last.is_a?(Hash)
      args.last.merge!(defaults)
    else
      args << defaults
    end
    resources res, *args, &block
  end

  devise_for :auths,
             controllers: {
               omniauth_callbacks: 'omniauth',
               sessions: 'sessions'
             }

  delete 'logout', to: 'sessions#destroy'

  api_resources :users do
    api_resources :auths, except: %i[create]
  end

  match '*unmatched', to: 'errors#not_found', via: :all
end
