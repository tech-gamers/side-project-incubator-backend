class StaticController < ApplicationController
  def index
    render json: {
      homepage: 'https://tech-gamers.live',
      version: '1.0.0'
    }
  end
end
