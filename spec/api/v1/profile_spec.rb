# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Profiles API', type: :request do
  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }
  end

  describe 'GET /api/v1/profiles/me' do
    context 'when not authorized' do
      it 'returns 401 if there is no access_token' do
        get('/api/v1/profiles/me', headers:)

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns 401 if access_token is invalid' do
        get('/api/v1/profiles/me', params: { access_token: '123' }, headers:)

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get('/api/v1/profiles/me', params: { access_token: access_token.token }, headers:) }

      it 'returns 200' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id email created_at updated_at].each do |attribute|
          expect(json[attribute]).to eq(me.send(attribute).as_json)
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attribute|
          expect(json).not_to have_key(attribute)
        end
      end
    end
  end
end
