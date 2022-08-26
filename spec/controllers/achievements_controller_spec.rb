# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AchievementsController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #show' do
    context 'when user is authenticated' do
      before do
        login(user)
        get :show
      end

      it 'renders show view' do
        expect(response).to render_template :show
      end
    end

    context 'when user is not authenticated' do
      before { get :show }

      it 'redirects to sign in' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
