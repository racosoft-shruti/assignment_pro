class Assignment::LoginsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      # User is authenticated
      render json: {
        id: user.id,
        email: user.email,
        token: Token::JsonWebToken.encode(user.id), ## 24 hrs
        refresh_token: Token::JsonWebToken.encode(user.id, 1.year.from_now)
      }
    else
      # Authentication failed
      render json: {errors: [message: 'User logged in failed']}, status: :unauthorized
    end
  end
end
