# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'votable' do
  it { should have_many(:votes).dependent(:destroy) }

  it '#rating' do
    votable = create(described_class.to_s.underscore.to_sym, user: create(:user))
    votable.votes << create(:vote)

    expect(votable.rating).to eq(1)
  end
end
