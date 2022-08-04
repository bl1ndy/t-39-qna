# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question, user:) }
  let!(:another_question) { create(:question, user: another_user) }

  describe 'GET #index' do
    it 'renders index view' do
      get :index

      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'renders show view' do
      get :show, params: { id: question }

      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it 'renders new view' do
      login(user)
      get :new

      expect(response).to render_template :new
    end

    context 'when user is not authenticated' do
      it 'redirects to sign in' do
        get :new

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      before { login(user) }

      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'redirects to show' do
        post :create, params: { question: attributes_for(:question) }

        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      before { login(user) }

      it 'does not save a question' do
        expect do
          post :create, params: { question: attributes_for(:question, :invalid) }
        end.not_to change(Question, :count)
      end

      it 're-renders new' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to render_template :new
      end
    end

    context 'when user is not authenticated' do
      it 'does not save a question' do
        expect { post :create, params: { question: attributes_for(:question) } }.not_to change(Question, :count)
      end

      it 'redirects to sign in' do
        post :create, params: { question: attributes_for(:question) }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      before do
        login(user)
        patch :update,
              params: { id: question, question: { title: 'updated title', body: 'updated body' } },
              format: :js
      end

      it 'changes question attributes' do
        question.reload

        expect(question.title).to eq('updated title')
        expect(question.body).to eq('updated body')
      end

      it 'renders update' do
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before do
        login(user)
        patch :update,
              params: { id: question, question: attributes_for(:question, :invalid) },
              format: :js
      end

      it 'does not change the question' do
        question.reload

        expect(question.title).to eq('MyQuestionTitle')
        expect(question.body).to eq('MyQuestionText')
      end

      it 'renders update' do
        expect(response).to render_template :update
      end
    end

    context "when user is not question's author" do
      before do
        login(user)
        patch :update,
              params: { id: another_question, question: { title: 'updated title', body: 'updated body' } },
              format: :js
      end

      it 'does not change answer attributes' do
        another_question.reload

        expect(another_question.title).to eq('MyQuestionTitle')
        expect(another_question.body).to eq('MyQuestionText')
      end

      it 'gets 403 status' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when user is not authenticated' do
      before do
        patch :update,
              params: { id: question, question: { title: 'updated title', body: 'updated body' } },
              format: :js
      end

      it 'does not change answer attributes' do
        question.reload

        expect(question.title).to eq('MyQuestionTitle')
        expect(question.body).to eq('MyQuestionText')
      end

      it 'gets 401 status' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    context "when user is question's author" do
      before { login(user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
      end
    end

    context "when user is not question's author" do
      before { login(user) }

      it 'does not delete the question' do
        expect do
          delete :destroy, params: { id: another_question }
        end.not_to change(Question, :count)
      end

      it 'gets 403 status' do
        delete :destroy, params: { id: another_question }

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when user is not authenticated' do
      it 'does not delete the question' do
        expect do
          delete :destroy, params: { id: question }
        end.not_to change(Question, :count)
      end

      it 'redirects to sign in' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
