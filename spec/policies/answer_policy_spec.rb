# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswerPolicy, type: :policy do
  subject { described_class.new(user, answer) }

  context 'when request is from an authenticated user' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer, user: create(:user)) }

    it { should_not permit_action(:update) }
    it { should_not permit_action(:destroy) }
    it { should_not permit_action(:destroy_link) }
    it { should_not permit_action(:destroy_file) }
    it { should_not permit_action(:best) }
  end

  context "when request is from the answer's author" do
    let(:user) { create(:user) }
    let(:answer) { create(:answer, user:) }

    it { should permit_action(:update) }
    it { should permit_action(:destroy) }
    it { should permit_action(:destroy_link) }
    it { should permit_action(:destroy_file) }

    it { should_not permit_action(:best) }
  end

  context "when request is from the question's author" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user:) }
    let(:answer) { create(:answer, question:, user: create(:user)) }

    it { should permit_action(:best) }
  end
end
