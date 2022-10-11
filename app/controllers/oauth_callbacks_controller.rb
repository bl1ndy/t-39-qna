# frozen_string_literal: true

class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    authorize_via_oauth('Github')
  end

  def vkontakte
    authorize_via_oauth('VK')
  end

  private

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def authorize_via_oauth(provider)
    auth = request.env['omniauth.auth']
    user = FindForOauthService.new(auth).call

    if user&.persisted?
      sign_in_and_redirect(user, event: :authentication)
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    elsif auth.info&.email.nil?
      session[:oauth_provider] = auth.provider
      session[:oauth_uid] = auth.uid

      render 'users/confirm_email'
    else
      redirect_to root_path
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
