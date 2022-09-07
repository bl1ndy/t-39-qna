# frozen_string_literal: true

require 'rails_helper'

shared_examples 'voted' do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:votable_name) { described_class.controller_name.classify.underscore.to_sym }
  let(:votable) { create(votable_name, user:) }
  let(:another_votable) { create(votable_name, user: another_user) }

  describe 'POST #vote_up' do
    context 'when user is authenticated' do
      before { login(user) }

      it 'adds a vote' do
        expect { post :vote_up, params: { id: another_votable } }.to change(another_votable.votes, :count).by(1)
      end
    end

    context "when user is the post's author" do
      before do
        login(user)
        post :vote_up, params: { id: votable }
      end

      it 'gets 422 status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when post already has user's vote" do
      before do
        login(user)
        post :vote_up, params: { id: another_votable }
      end

      it 'gets 422 status' do
        post :vote_up, params: { id: another_votable }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user is not authenticated' do
      it 'does not add a vote' do
        expect { post :vote_up, params: { id: votable } }.not_to change(votable.votes, :count)
      end

      it 'redirects to sign in' do
        post :vote_up, params: { id: votable }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'POST #vote_down' do
    context 'when user is authenticated' do
      before { login(user) }

      it 'adds a vote' do
        expect { post :vote_down, params: { id: another_votable } }.to change(another_votable.votes, :count).by(1)
      end
    end

    context "when user is the post's author" do
      before do
        login(user)
        post :vote_down, params: { id: votable }
      end

      it 'gets 422 status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when post already has user's vote" do
      before do
        login(user)
        post :vote_down, params: { id: another_votable }
      end

      it 'gets 422 status' do
        post :vote_down, params: { id: another_votable }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user is not authenticated' do
      it 'does not add a vote' do
        expect { post :vote_down, params: { id: votable } }.not_to change(votable.votes, :count)
      end

      it 'redirects to sign in' do
        post :vote_down, params: { id: votable }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE #cancel_vote' do
    context 'when user is authenticated' do
      before do
        login(user)
      end

      it "deletes an existing user's vote" do
        create(:vote, user:, votable: another_votable)

        expect { delete :cancel_vote, params: { id: another_votable } }.to change(another_votable.votes, :count).by(-1)
      end

      it 'does not delete vote of another user' do
        create(:vote, user: create(:user), votable: another_votable)

        expect { delete :cancel_vote, params: { id: another_votable } }.not_to change(another_votable.votes, :count)
      end
    end

    context 'when user is not authenticated' do
      it 'does not delete a vote' do
        expect { delete :cancel_vote, params: { id: another_votable } }.not_to change(another_votable.votes, :count)
      end

      it 'redirects to sign in' do
        delete :cancel_vote, params: { id: another_votable }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
