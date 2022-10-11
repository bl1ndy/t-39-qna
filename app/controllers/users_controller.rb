# frozen_string_literal: true

class UsersController < ApplicationController
  def confirm_email
    auth = OmniAuth::AuthHash.new(
      provider: session[:oauth_provider],
      uid: session[:oauth_uid].to_s,
      info: { email: params[:user][:email] },
      should_be_confirmed: true
    )
    user = FindForOauthService.new(auth).call

    sign_in_and_redirect(user, event: :authentication)
  end

  private

  def user_params
    require(:user).permit(:email)
  end
end
