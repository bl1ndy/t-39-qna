# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FindForOauthService do
  subject(:service) { described_class.new(auth) }

  let!(:user) { create(:user) }

  context 'when user already has oauth' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456') }

    before do
      user.authorizations.create(provider: 'github', uid: '123456')
    end

    it 'returns the user' do
      expect(service.call).to eq(user)
    end
  end

  context 'when user has no oauth but already exists' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: user.email }) }

    it 'does not create new user' do
      expect { service.call }.not_to change(User, :count)
    end

    it 'creates authorization for user' do
      expect { service.call }.to change(user.authorizations, :count).by(1)
    end

    it 'creates authorization with correct oauth data' do
      authorization = service.call.authorizations.first

      expect(authorization.provider).to eq(auth.provider)
      expect(authorization.uid).to eq(auth.uid.to_s)
    end

    it 'returns the user' do
      expect(service.call).to eq(user)
    end
  end

  context 'when user does not exist' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: 'new@user.com' }) }

    it 'creates new user' do
      expect { service.call }.to change(User, :count).by(1)
    end

    it 'creates new user with correct data' do
      user = service.call

      expect(user.email).to eq(auth.info.email)
    end

    it 'creates authorization for new user' do
      user = service.call

      expect(user.authorizations).not_to be_empty
    end

    it 'creates authorization for new user with correct oauth data' do
      authorization = service.call.authorizations.first

      expect(authorization.provider).to eq(auth.provider)
      expect(authorization.uid).to eq(auth.uid.to_s)
    end

    it 'returns the user' do
      expect(service.call).to be_a(User)
    end
  end
end
