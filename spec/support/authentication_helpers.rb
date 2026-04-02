module AuthenticationHelpers
  def sign_in(user)
    # For request specs, use API login
    if defined?(request) && request.present?
      post '/auth/login', params: { email: user.email, password: user.password }
    else
      post '/sign_in', params: { session: { email: user.email, password: user.password } }
    end
  end

  def sign_out
    if defined?(request) && request.present?
      post '/auth/logout'
    else
      delete '/sign_out'
    end
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelpers, type: :request
end