# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user:) }
  let!(:answer) { create(:answer, question:, user:) }

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(user) }

      it 'saves a new comment for question in the database' do
        expect do
          post :create,
               params: { question_id: question, comment: attributes_for(:comment) },
               format: :js
        end.to change(Comment, :count).by(1)
      end

      it 'saves a new comment for answer in the database' do
        expect do
          post :create,
               params: { answer_id: answer, comment: attributes_for(:comment) },
               format: :js
        end.to change(Comment, :count).by(1)
      end

      it 'renders create' do
        post :create,
             params: { question_id: question, comment: attributes_for(:comment) },
             format: :js

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not save a comment' do
        expect do
          post :create,
               params: { question_id: question, comment: attributes_for(:comment, :invalid) },
               format: :js
        end.not_to change(Comment, :count)
      end

      it 'renders create' do
        post :create,
             params: { question_id: question, comment: attributes_for(:comment, :invalid) },
             format: :js

        expect(response).to render_template :create
      end
    end

    context 'when user is not authenticated' do
      it 'does not save an answer' do
        expect do
          post :create,
               params: { question_id: question, comment: attributes_for(:comment) },
               format: :js
        end.not_to change(Comment, :count)
      end

      it 'gets 401 status' do
        post :create,
             params: { question_id: question, comment: attributes_for(:comment) },
             format: :js

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
