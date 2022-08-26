# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reward, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user).optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:image_url) }
  end
end
