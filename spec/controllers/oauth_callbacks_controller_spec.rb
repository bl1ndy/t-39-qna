# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'GET #github' do
    let(:oauth_data) { OmniAuth::AuthHash.new(provider: 'github', uid: '123', info: { email: 'oauth@test.com' }) }
    let(:service) { instance_double(FindForOauthService) }

    before do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      allow(FindForOauthService).to receive(:new).with(oauth_data).and_return(service)
    end

    it 'tries to find user from auth data' do
      allow(service).to receive(:call)
      get :github

      expect(service).to have_received(:call)
    end

    context 'when user exists' do
      let(:user) { create(:user) }

      before do
        allow(service).to receive(:call).and_return(user)
        get :github
      end

      it 'authenticates user' do
        expect(subject.current_user).to eq(user) # rubocop:disable RSpec/NamedSubject
      end

      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user does not exist' do
      before do
        allow(service).to receive(:call)
        get :github
      end

      it 'does not authenticate user' do
        expect(subject.current_user).to be_nil # rubocop:disable RSpec/NamedSubject
      end

      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #vkontakte' do
    let(:oauth_data) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123') }
    let(:service) { instance_double(FindForOauthService) }

    before do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      allow(FindForOauthService).to receive(:new).with(oauth_data).and_return(service)
    end

    it 'tries to find user from auth data' do
      allow(service).to receive(:call)
      get :vkontakte

      expect(service).to have_received(:call)
    end

    context 'when user exists and already has vk oauth' do
      let(:user) { create(:user) }

      before do
        allow(service).to receive(:call).and_return(user)
        get :vkontakte
      end

      it 'authenticates user' do
        expect(subject.current_user).to eq(user) # rubocop:disable RSpec/NamedSubject
      end

      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when user does not exist or have no vk oauth' do
      before do
        allow(service).to receive(:call)
        get :vkontakte
      end

      it 'does not authenticate user' do
        expect(subject.current_user).to be_nil # rubocop:disable RSpec/NamedSubject
      end

      it 'renders confirm_email' do
        expect(response).to render_template 'users/confirm_email'
      end
    end
  end
end
