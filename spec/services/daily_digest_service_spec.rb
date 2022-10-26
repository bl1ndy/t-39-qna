# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyDigestService do
  subject(:daily_digest) { described_class.new }

  let(:users) { create_list(:user, 3) }

  # rubocop:disable RSpec/MessageSpies
  it 'sends daily digest to all users' do
    users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original }
    daily_digest.send_digest
  end
  # rubocop:enable RSpec/MessageSpies
end
