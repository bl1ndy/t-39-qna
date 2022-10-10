# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    authorize_via_oauth('Github')
  end

  def vkontakte
    authorize_via_oauth('VK')
  end

  private

  def authorize_via_oauth(provider)
    user = FindForOauthService.new(request.env['omniauth.auth']).call

    if user&.persisted?
      sign_in_and_redirect(user, event: :authentication)
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path
    end
  end
end
