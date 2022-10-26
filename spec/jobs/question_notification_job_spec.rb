# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionNotificationJob, type: :job do
  let(:service) { instance_double(QuestionNotificationService) }
  let(:question) { create(:question) }

  before do
    allow(QuestionNotificationService).to receive(:new).with(question).and_return(service)
  end

  it 'calls QuestionNotificationService#call' do
    allow(service).to receive(:call)
    described_class.perform_now(question)

    expect(service).to have_received(:call)
  end
end
