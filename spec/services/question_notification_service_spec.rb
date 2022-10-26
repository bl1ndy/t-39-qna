# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionNotificationService do
  subject(:notification_service) { described_class.new(question) }

  let(:users) { create_list(:user, 2) }
  let(:question) { create(:question) }

  before do
    question.subscriptions.create(user: users.first)
    question.subscriptions.create(user: users.last)
  end

  # rubocop:disable RSpec/MessageSpies
  it 'sends new answer notification to all question subscribers' do
    users.each do |user|
      expect(QuestionNotificationMailer).to receive(:notify).with(question, user).and_call_original
    end

    notification_service.call
  end
  # rubocop:enable RSpec/MessageSpies
end
