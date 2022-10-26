# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionNotificationMailer, type: :mailer do
  describe 'notify' do
    let(:question) { create(:question) }
    let(:user) { create(:user) }
    let(:mail) { described_class.notify(question, user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('New answer received')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'contains title of subscribed question' do
      expect(mail.body.encoded).to match(question.title)
    end
  end
end
