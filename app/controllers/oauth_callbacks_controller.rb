# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    user = FindForOauthService.new(request.env['omniauth.auth']).call

    if user&.persisted?
      sign_in_and_redirect(user, event: :authentication)
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      flash[:alert] = 'Oauth error!'

      redirect_to root_path
    end
  end
end
