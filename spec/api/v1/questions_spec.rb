# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Questions API', type: :request do
  let(:headers) do
    {
      'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json'
    }
  end

  describe 'GET /api/v1/questions' do
    context 'when not authorized' do
      it 'returns 401 if there is no access_token' do
        get('/api/v1/questions', headers:)

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns 401 if access_token is invalid' do
        get('/api/v1/questions', params: { access_token: '123' }, headers:)

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question:, user: create(:user)) }

      before { get('/api/v1/questions', params: { access_token: access_token.token }, headers:) }

      it 'returns 200' do
        expect(response).to be_successful
      end

      it 'returns questions list' do
        expect(json['questions'].size).to eq(2)
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

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns answers list' do
          expect(question_response['answers'].size).to eq(3)
        end

        it 'returns all public fields' do
          %w[id body question_id user_id created_at updated_at].each do |attribute|
            expect(answer_response[attribute]).to eq(answer.send(attribute).as_json)
          end
        end
      end
    end
  end
end
