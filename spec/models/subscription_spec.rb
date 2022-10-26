# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it 'validates uniqueness of question with scope of user' do
      user = create(:user)
      question = create(:question)
      subscription = user.subscriptions.create(question:)

      expect(subscription).to validate_uniqueness_of(:question_id).scoped_to(:user_id)
    end
  end
end
