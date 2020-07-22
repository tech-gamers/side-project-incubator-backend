# Served as Warden's failure application
class UnauthorizedController < ApplicationController
  class << self
    def call(env)
      @respond ||= action(:respond)
      @respond.call(env)
    end
  end

  def respond
    render json: {}, status: :unauthorized
  end
end
