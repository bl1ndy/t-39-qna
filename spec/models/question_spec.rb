# frozen_string_literal: true

require 'rails_helper'
require_relative 'concerns/votable'
require_relative 'concerns/commentable'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should have_one(:reward).dependent(:destroy) }

    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
    it { should have_many_attached(:files) }

    it { should belong_to(:best_answer).class_name('Answer').optional }

    it { should accept_nested_attributes_for(:links) }
    it { should accept_nested_attributes_for(:reward) }

    it_behaves_like 'votable'
    it_behaves_like 'commentable'
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end

  describe 'callbacks' do
    let(:question) { create(:question) }

    it 'fires subscribe_author callback after create' do
      allow(question).to receive(:subscribe_author)
      question.run_callbacks(:create)

      expect(question).to have_received(:subscribe_author)
    end
  end
end
