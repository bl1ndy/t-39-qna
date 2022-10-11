# frozen_string_literal: true

class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  # rubocop:disable Metrics/AbcSize
  def call
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)

    return authorization.user if authorization

    email = auth.info.email
    user = User.find_by(email:)

    unless user
      password = Devise.friendly_token(8)
      user = User.create!(email:, password:, password_confirmation: password, confirmed_at: Time.zone.now)
    end

    user.authorizations.create(provider: auth.provider, uid: auth.uid.to_s)

    user
  end
  # rubocop:enable Metrics/AbcSize
end
