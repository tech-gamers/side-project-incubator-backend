Rails.application.routes.draw do
  def api_resources(res, *args, &block)
    defaults = {
      format: :json,
      only: %i[index show create update destroy]
    }
    # this will be changed in Rails 6.1
    if args.length.positive? && args.last.is_a?(Hash)
      args[-1] = defaults.merge(args.last)
    else
      args << defaults
    end
    resources res, *args, &block
  end

  api_resources :users do
    collection do
      get :current
    end
    api_resources :auths, only: %i[index create destroy]
  end

  match '*unmatched', to: 'errors#not_found', via: :all
end
