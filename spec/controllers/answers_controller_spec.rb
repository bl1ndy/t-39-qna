# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user:) }
  let!(:answer) { create(:answer, question:, user:) }
  let!(:another_answer) { create(:answer, question:, user: another_user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(user) }

      it 'saves a new answer for current question in the database' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
        end.to change(Answer, :count).by(1)
      end

      it 'redirects to question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }

        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not save an answer' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        end.not_to change(Answer, :count)
      end

      it 're-renders questions show' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }

        expect(response).to render_template 'questions/show'
      end
    end

    context 'when user is not authenticated' do
      it 'does not save an answer' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
        end.not_to change(Answer, :count)
      end

      it 'redirects to sign_in' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context "when user is answer's author" do
      before { login(user) }

      it 'deletes an answer' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer, question_id: question }

        expect(response).to redirect_to question
      end
    end

    context "when user is not answer's author" do
      before { login(user) }

      it 'does not delete an answer' do
        expect do
          delete :destroy, params: { id: another_answer, question_id: question }
        end.not_to change(Answer, :count)
      end

      it 'gets 403 status' do
        delete :destroy, params: { id: another_answer, question_id: question }

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when user is not authenticated' do
      it 'does not delete an answer' do
        expect do
          delete :destroy, params: { id: answer, question_id: question }
        end.not_to change(Answer, :count)
      end

      it 'redirects to sign_in' do
        delete :destroy, params: { id: answer, question_id: question }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
