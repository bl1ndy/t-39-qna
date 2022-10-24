# frozen_string_literal: true

require 'rails_helper'
require_relative 'concern/api_authorizable'

RSpec.describe 'Questions API', type: :request do
  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }
  end

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'when authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }

      before { get(api_path, params: { access_token: access_token.token }, headers:) }

      it 'returns 200' do
        expect(response).to be_successful
      end

      it 'returns questions list' do
        expect(json['questions'].size).to eq(questions.size)
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'when authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }

      before do
        create_list(:comment, 3, commentable: question, user: create(:user))
        create_list(:link, 3, linkable: question)
        question.files.attach(io: File.open(Rails.root.join('spec/rails_helper.rb')), filename: 'rails_helper.rb')

        get(api_path, params: { access_token: access_token.token }, headers:)
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attribute|
          expect(question_response[attribute]).to eq(question.send(attribute).as_json)
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq(question.user.id)
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq(question.title.truncate(10))
      end

      it 'contains comments list' do
        expect(question_response['comments'].size).to eq(question.comments.size)
      end

      it 'contains links list' do
        expect(question_response['links'].size).to eq(question.links.size)
      end

      it 'contains files urls list' do
        file_url = Rails.application.routes.url_helpers.rails_blob_path(question.files.first, only_path: true)

        expect(question_response['files'].size).to eq(question.files.size)
        expect(question_response['files'].first['url']).to eq(file_url)
      end
    end
  end
end
