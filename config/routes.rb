Rails.application.routes.draw do
  %i[resource resources].each do |resource|
    define_singleton_method("api_#{resource}") do |res, *args, &block|
      defaults = {
        format: :json,
        only: %i[index show create update destroy]
      }
      # last-arg-as-options will be changed in Rails 6.1
      if args.length.positive? && args.last.is_a?(Hash)
        args[-1] = defaults.merge(args.last)
      else
        args << defaults
      end
      send(resource, res, *args, &block)
    end
  end

  namespace :auth do
    post '/:provider/callback', to: '/sessions#create', as: 'callback'
  end

  api_resource :user, controller: :user, only: %i[show update destroy] do
    api_resource :session, only: %i[show destroy]
  end

  api_resources :users do
    api_resources :auths, only: %i[index create destroy]
  end

  match '*unmatched', to: 'errors#not_found', via: :all
end
