# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question, user:) }
  let(:file) { fixture_file_upload(Rails.root.join('spec/rails_helper.rb')) }

  describe 'GET #index' do
    it 'renders index view' do
      get :index

      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns a new Link to @answer.links.build' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    context 'when user is authenticated' do
      before do
        login(user)
        get :new
      end

      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'assigns a new Link to @question.links.build' do
        expect(assigns(:question).links.first).to be_a_new(Link)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
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
        expect do
          post :create,
               params: { question: attributes_for(:question).merge(files: [file]) }
        end.to change(Question, :count).by(1)
      end

      it 'redirects to show' do
        post :create, params: { question: attributes_for(:question).merge(files: [file]) }

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
              params: {
                id: question,
                question: { title: 'updated title', body: 'updated body', files: [file] }
              },
              format: :js
      end

      it 'changes question attributes' do
        question.reload

        expect(question.title).to eq('updated title')
        expect(question.body).to eq('updated body')
        expect(question.files.first.filename).to eq('rails_helper.rb')
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
        login(another_user)
        patch :update,
              params: {
                id: question,
                question: { title: 'updated title', body: 'updated body', files: [file] }
              },
              format: :js
      end

      it 'does not change question attributes' do
        question.reload

        expect(question.title).to eq('MyQuestionTitle')
        expect(question.body).to eq('MyQuestionText')
        expect(question.files).to be_empty
      end

      it 'gets 403 status' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when user is not authenticated' do
      before do
        patch :update,
              params: {
                id: question,
                question: { title: 'updated title', body: 'updated body', files: [file] }
              },
              format: :js
      end

      it 'does not change question attributes' do
        question.reload

        expect(question.title).to eq('MyQuestionTitle')
        expect(question.body).to eq('MyQuestionText')
        expect(question.files).to be_empty
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
      before { login(another_user) }

      it 'does not delete the question' do
        expect do
          delete :destroy, params: { id: question }
        end.not_to change(Question, :count)
      end

      it 'gets 403 status' do
        delete :destroy, params: { id: question }

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

  describe 'DELETE#destroy_file' do
    before do
      question.files.attach(
        io: File.open(Rails.root.join('spec/rails_helper.rb')),
        filename: 'rails_helper.rb'
      )
    end

    context "when user is question's author" do
      before { login(user) }

      it 'deletes attached file' do
        expect do
          delete :destroy_file,
                 params: { id: question, file_id: question.files.first.id },
                 format: :js
        end.to change(question.files, :count).by(-1)
      end

      it 'renders destroy_file' do
        delete :destroy_file,
               params: { id: question, file_id: question.files.first.id },
               format: :js

        expect(response).to render_template :destroy_file
      end
    end

    context "when user is not question's author" do
      before { login(another_user) }

      it 'does not delete attached file' do
        expect do
          delete :destroy_file,
                 params: { id: question, file_id: question.files.first.id },
                 format: :js
        end.not_to change(question.files, :count)
      end

      it 'gets 403 status' do
        delete :destroy_file,
               params: { id: question, file_id: question.files.first.id },
               format: :js

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when user is not authenticated' do
      it 'does not delete attached file' do
        expect do
          delete :destroy_file,
                 params: { id: question, file_id: question.files.first.id },
                 format: :js
        end.not_to change(question.files, :count)
      end

      it 'gets 401 status' do
        delete :destroy_file,
               params: { id: question, file_id: question.files.first.id },
               format: :js

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
