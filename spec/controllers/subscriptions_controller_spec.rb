# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'when user is authenticated' do
      before { login(user) }

      it 'creates new subscription' do
        expect do
          post :create, params: { question_id: question }, format: :js
        end.to change(question.subscriptions, :count).by(1)
      end

      it 'renders create' do
        post :create, params: { question_id: question }, format: :js

        expect(response).to render_template :create
      end
    end

    context 'when user is not authenticated' do
      it 'does not create new subscription' do
        expect do
          post :create, params: { question_id: question }, format: :js
        end.not_to change(question.subscriptions, :count)
      end

      it 'gets 401 status' do
        post :create, params: { question_id: question }, format: :js

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is authenticated' do
      before { login(user) }

      it 'deletes the subscription' do
        expect do
          delete :destroy, params: { id: question.subscriptions.first }, format: :js
        end.to change(question.subscriptions, :count).by(-1)
      end

      it 'renders destroy' do
        delete :destroy, params: { id: question.subscriptions.first }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'when user is not authenticated' do
      it 'does not delete any subscription' do
        expect do
          delete :destroy, params: { id: question.subscriptions.first }, format: :js
        end.not_to change(question.subscriptions, :count)
      end

      it 'gets 401 status' do
        delete :destroy, params: { id: question.subscriptions.first }, format: :js

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
