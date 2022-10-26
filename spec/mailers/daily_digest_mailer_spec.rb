# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyDigestMailer, type: :mailer do
  describe 'digest' do
    let!(:yesterday_question) { create(:question, created_at: 1.day.ago) }
    let!(:today_question) { create(:question, title: 'Today Question') }
    let(:user) { create(:user) }
    let(:mail) { described_class.digest(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Digest')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'contains only yesterday questions' do
      expect(mail.body.encoded).to match(yesterday_question.title)
      expect(mail.body.encoded).not_to match(today_question.title)
    end
  end
end
