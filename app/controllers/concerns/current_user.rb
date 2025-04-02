module CurrentUser
  private

  def current_user
    @current_user ||= User.find_by(id: @token.id)

    return render json: {
      errors: [message: 'User is not found.']
    }, status: 404 if @current_user.blank?
  end
end
