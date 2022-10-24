# frozen_string_literal: true

require 'rails_helper'
require_relative 'concern/api_authorizable'

RSpec.describe 'Answers API', type: :request do
  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }
  end

  let(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 3, question:, user: create(:user)) }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'when authorized' do
      let(:access_token) { create(:access_token) }

      before { get(api_path, params: { access_token: access_token.token }, headers:) }

      it 'returns 200' do
        expect(response).to be_successful
      end

      it 'returns answers list for provided question' do
        expect(json['answers'].size).to eq(answers.size)
      end
    end
  end

  describe 'GET /api/v1/questions/:question_id/answers/:id' do
    let(:answer) { answers.first }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    # rubocop:disable RSpec/MultipleMemoizedHelpers
    context 'when authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }

      before do
        create_list(:comment, 3, commentable: answer, user: create(:user))
        create_list(:link, 3, linkable: answer)
        answer.files.attach(io: File.open(Rails.root.join('spec/rails_helper.rb')), filename: 'rails_helper.rb')

        get(api_path, params: { access_token: access_token.token }, headers:)
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attribute|
          expect(answer_response[attribute]).to eq(answer.send(attribute).as_json)
        end
      end

      it 'contains user object' do
        expect(answer_response['user']['id']).to eq(answer.user.id)
      end

      it 'contains comments list' do
        expect(answer_response['comments'].size).to eq(answer.comments.size)
      end

      it 'contains links list' do
        expect(answer_response['links'].size).to eq(answer.links.size)
      end

      it 'contains files urls list' do
        file_url = Rails.application.routes.url_helpers.rails_blob_path(answer.files.first, only_path: true)

        expect(answer_response['files'].size).to eq(answer.files.size)
        expect(answer_response['files'].first['url']).to eq(file_url)
      end
    end
    # rubocop:enable RSpec/MultipleMemoizedHelpers
  end
end
