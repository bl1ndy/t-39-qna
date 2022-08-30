# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'associations' do
    it { should belong_to(:votable) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_numericality_of(:rate).only_integer }
    it { should allow_value(1).for(:rate) }
    it { should allow_value(-1).for(:rate) }
    it { should_not allow_value(2).for(:rate) }

    context 'with scope of votable_type and user_id' do
      subject(:vote) { create(:vote) }

      it 'validates uniqueness of votable_id' do
        expect(vote).to validate_uniqueness_of(:votable_id)
          .scoped_to(:votable_type, :user_id)
          .with_message('You have already voted for this post')
      end
    end
  end
end
