# frozen_string_literal: true

require 'rails_helper'
require_relative 'concern/api_authorizable'

RSpec.describe 'Answers API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

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

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'with valid attributes' do
      let(:access_token) { create(:access_token) }

      it 'saves a new answer in the database' do
        expect do
          post(api_path,
               params: { access_token: access_token.token, question_id: question, answer: attributes_for(:answer) },
               headers:)
        end.to change(Answer, :count).by(1)
      end

      it 'returns 201' do
        post(api_path,
             params: { access_token: access_token.token, question_id: question, answer: attributes_for(:answer) },
             headers:)

        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      let(:access_token) { create(:access_token) }

      it 'does not save an answer' do
        expect do
          post(api_path,
               params: {
                 access_token: access_token.token,
                 question_id: question,
                 answer: attributes_for(:answer, :invalid)
               },
               headers:)
        end.not_to change(Answer, :count)
      end

      it 'returns 422' do
        post(api_path,
             params: {
               access_token: access_token.token,
               question_id: question,
               answer: attributes_for(:answer, :invalid)
             },
             headers:)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns answer errors' do
        post(api_path,
             params: {
               access_token: access_token.token,
               question_id: question,
               answer: attributes_for(:answer, :invalid)
             },
             headers:)

        expect(json['errors']).not_to be_empty
      end
    end
  end

  # rubocop:disable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
  describe 'PATCH /api/v1/questions/:question_id/answers/:id' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question:, user: create(:user)) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    describe "by answer's author" do
      let(:access_token) { create(:access_token, resource_owner_id: answer.user.id) }

      context 'with valid attributes' do
        before do
          patch(api_path,
                params: { access_token: access_token.token, question_id: question, answer: { body: 'Updated body' } },
                headers:)
        end

        it 'changes answer attributes' do
          answer.reload

          expect(answer.body).to eq('Updated body')
        end

        it 'returns 201' do
          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid attributes' do
        before do
          patch(api_path,
                params: {
                  access_token: access_token.token,
                  question_id: question,
                  answer: attributes_for(:answer, :invalid)
                },
                headers:)
        end

        it 'does not change answer attributes' do
          answer.reload

          expect(answer.body).not_to eq('')
        end

        it 'returns 422' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns answer errors' do
          expect(json['errors']).not_to be_empty
        end
      end
    end

    describe 'by another user' do
      let(:access_token) { create(:access_token) }

      before do
        patch(api_path,
              params: { access_token: access_token.token, question_id: question, answer: { body: 'Updated body' } },
              headers:)
      end

      it 'does not change answer attributes' do
        expect(answer.body).not_to eq('Updated body')
      end

      it 'returns 403' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE /api/v1/questions/:question_id/answers/:id' do
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, question:, user: create(:user)) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context "when user is answer's author" do
      let(:access_token) { create(:access_token, resource_owner_id: answer.user.id) }

      it 'deletes the answer' do
        expect do
          delete(api_path,
                 params: { access_token: access_token.token, question_id: question, id: answer },
                 headers:)
        end.to change(Answer, :count).by(-1)
      end

      it 'returns 200' do
        delete(api_path,
               params: { access_token: access_token.token, question_id: question, id: answer },
               headers:)

        expect(response).to have_http_status(:ok)
      end
    end

    context "when user is not answer's author" do
      let(:access_token) { create(:access_token) }

      it 'does not delete the answer' do
        expect do
          delete(api_path,
                 params: { access_token: access_token.token, question_id: question, id: answer },
                 headers:)
        end.not_to change(Answer, :count)
      end

      it 'returns 403' do
        delete(api_path,
               params: { access_token: access_token.token, question_id: question, id: answer },
               headers:)

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups, RSpec/MultipleMemoizedHelpers
end
