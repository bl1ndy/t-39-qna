# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many_attached(:files) }

    it { should accept_nested_attributes_for(:links) }
  end

  describe 'validations' do
    it { should validate_presence_of(:body) }
  end
end
