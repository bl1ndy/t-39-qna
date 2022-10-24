# frozen_string_literal: true

require 'rails_helper'
require_relative 'concern/api_authorizable'

RSpec.describe 'Profiles API', type: :request do
  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }
  end

  describe 'GET /api/v1/profiles' do
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'when authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        create_list(:user, 3)
        get(api_path, params: { access_token: access_token.token }, headers:)
      end

      it 'returns 200' do
        expect(response).to be_successful
      end

      it 'returns all users except resource owner' do
        expect(json['users'].size).to eq(3)
      end
    end
  end

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'when authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get(api_path, params: { access_token: access_token.token }, headers:) }

      it 'returns 200' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email created_at updated_at].each do |attribute|
          expect(json['user'][attribute]).to eq(me.send(attribute).as_json)
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attribute|
          expect(json['user']).not_to have_key(attribute)
        end
      end
    end
  end
end
