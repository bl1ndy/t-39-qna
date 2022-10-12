# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionPolicy, type: :policy do
  subject { described_class.new(user, question) }

  context 'when request is from an authenticated user' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: create(:user)) }

    it { should_not permit_action(:update) }
    it { should_not permit_action(:destroy) }
    it { should_not permit_action(:destroy_link) }
    it { should_not permit_action(:destroy_file) }
  end

  context "when request is from the question's author" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user:) }

    it { should permit_action(:update) }
    it { should permit_action(:destroy) }
    it { should permit_action(:destroy_link) }
    it { should permit_action(:destroy_file) }
  end
end
