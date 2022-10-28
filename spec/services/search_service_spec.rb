# frozen_string_literal: true

require 'rails_helper'

SCOPES = %w[User Question Answer Comment].freeze

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe SearchService do
  let(:user) { create(:user) }
  let(:question) { create(:question, user:) }
  let(:answer) { create(:answer, question:, user:) }
  let(:comment) { create(:comment, commentable: answer, user:) }
  let(:all) { [user, question, answer, comment] }
  let(:results) { { 'User' => [user], 'Question' => [question], 'Answer' => [answer], 'Comment' => [comment] } }

  it 'calls search on ThinkingSphinx when scope is All' do
    allow(ThinkingSphinx).to receive(:search).with('test', order: 'created_at DESC').and_return(all)
    described_class.new('test', 'All').call

    expect(ThinkingSphinx).to have_received(:search)
  end

  SCOPES.each do |scope|
    it "calls search method on #{scope}" do
      allow(scope.constantize).to receive(:search).with('test', order: 'created_at DESC').and_return(results[scope])
      described_class.new('test', scope).call

      expect(scope.constantize).to have_received(:search)
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
