# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:service) { instance_double(DailyDigestService) }

  before do
    allow(DailyDigestService).to receive(:new).and_return(service)
  end

  it 'calls DailyDigestService#send_digest' do
    allow(service).to receive(:send_digest)
    described_class.perform_now

    expect(service).to have_received(:send_digest)
  end
end
