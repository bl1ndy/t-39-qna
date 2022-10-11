# frozen_string_literal: true

class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def call
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)

    return authorization.user if authorization

    return unless auth.info.email

    email = auth.info.email
    user = User.find_by(email:)

    unless user
      password = Devise.friendly_token(8)
      user = User.new(email:, password:, password_confirmation: password)
      user.skip_confirmation! unless should_be_confirmed?
      user.save!
    end

    user.authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
    user
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  private

  def should_be_confirmed?
    auth.should_be_confirmed
  end
end
