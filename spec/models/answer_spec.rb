# frozen_string_literal: true

require 'rails_helper'
require_relative 'concerns/votable'
require_relative 'concerns/commentable'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many_attached(:files) }

    it { should accept_nested_attributes_for(:links) }

    it_behaves_like 'votable'
    it_behaves_like 'commentable'
  end

  describe 'validations' do
    it { should validate_presence_of(:body) }
  end

  describe 'callbacks' do
    let(:answer) { create(:answer, user: create(:user)) }

    it 'fires notify_question_subscribers callback after create' do
      allow(answer).to receive(:notify_question_subscribers)
      answer.run_callbacks(:create)

      expect(answer).to have_received(:notify_question_subscribers)
    end
  end
end
