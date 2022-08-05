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
          post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        end.to change(Answer, :count).by(1)
      end

      it 'renders create' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not save an answer' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        end.not_to change(Answer, :count)
      end

      it 'renders create' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js

        expect(response).to render_template :create
      end
    end

    context 'when user is not authenticated' do
      it 'does not save an answer' do
        expect do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        end.not_to change(Answer, :count)
      end

      it 'gets 401 status' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before do
        login(user)
        patch :update, params: { id: answer, answer: { body: 'edited answer' } }, format: :js
      end

      it 'changes answer attributes' do
        answer.reload

        expect(answer.body).to eq('edited answer')
      end

      it 'renders update' do
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before do
        login(user)
        patch :update, params: { id: answer, answer: { body: '' } }, format: :js
      end

      it 'does not change answer attributes' do
        answer.reload

        expect(answer.body).not_to eq('')
      end

      it 'renders update' do
        expect(response).to render_template :update
      end
    end

    context "when user is not answer's author" do
      before do
        login(user)
        patch :update, params: { id: another_answer, answer: { body: 'edited answer' } }, format: :js
      end

      it 'does not change answer attributes' do
        another_answer.reload

        expect(another_answer.body).not_to eq('edited answer')
      end

      it 'gets 403 status' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when user is not authenticated' do
      before do
        patch :update, params: { id: answer, answer: { body: 'edited answer' } }, format: :js
      end

      it 'does not change answer attributes' do
        answer.reload

        expect(answer.body).not_to eq('edited answer')
      end

      it 'gets 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    context "when user is answer's author" do
      before { login(user) }

      it 'deletes an answer' do
        expect do
          delete :destroy, params: { id: answer, question_id: question }, format: :js
        end.to change(Answer, :count).by(-1)
      end

      it 'renders destroy' do
        delete :destroy, params: { id: answer, question_id: question }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context "when user is not answer's author" do
      before { login(user) }

      it 'does not delete an answer' do
        expect do
          delete :destroy, params: { id: another_answer, question_id: question }, format: :js
        end.not_to change(Answer, :count)
      end

      it 'gets 403 status' do
        delete :destroy, params: { id: another_answer, question_id: question }, format: :js

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when user is not authenticated' do
      it 'does not delete an answer' do
        expect do
          delete :destroy, params: { id: answer, question_id: question }, format: :js
        end.not_to change(Answer, :count)
      end

      it 'gets 401 status' do
        delete :destroy, params: { id: answer, question_id: question }, format: :js

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #best' do
    context "when user is question's author" do
      before do
        login(user)
        post :best, params: { id: answer }, format: :js
      end

      it "makes an answer the best for it's question" do
        question.reload

        expect(question.best_answer).to eq(answer)
      end

      it 'renders best' do
        expect(response).to render_template :best
      end
    end

    context "when user isn't question's author" do
      before do
        login(another_user)
        post :best, params: { id: answer }, format: :js
      end

      it "does not makes an answer the best for it's question" do
        question.reload

        expect(question.best_answer).not_to eq(answer)
      end

      it 'gets 403 status' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when user is not authenticated' do
      before { post :best, params: { id: answer }, format: :js }

      it "does not makes an answer the best for it's question" do
        question.reload

        expect(question.best_answer).not_to eq(answer)
      end

      it 'gets 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
