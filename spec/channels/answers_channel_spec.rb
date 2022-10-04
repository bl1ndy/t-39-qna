# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersChannel, type: :channel do
  it 'successfully subscribes' do
    subscribe question: 1

    expect(subscription).to be_confirmed
  end

  it 'rejects subscription' do
    subscribe question: nil

    expect(subscription).to be_rejected
  end
end
