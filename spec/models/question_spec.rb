# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should have_one(:reward).dependent(:destroy) }

    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many_attached(:files) }

    it { should belong_to(:best_answer).class_name('Answer').optional }

    it { should accept_nested_attributes_for(:links) }
    it { should accept_nested_attributes_for(:reward) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
  end
end
