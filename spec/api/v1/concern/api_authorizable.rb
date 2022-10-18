# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'API Authorizable' do
  context 'when not authorized' do
    it 'returns 401 if there is no access_token' do
      do_request(method, api_path, headers:)

      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 401 if access_token is invalid' do
      do_request(method, api_path, params: { access_token: '123' }, headers:)

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
