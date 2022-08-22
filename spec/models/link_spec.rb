# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'associations' do
    it { should belong_to(:linkable) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:url) }

    it { should allow_value('http://example.com', 'https://example.com').for(:url) }
    it { should_not allow_value('ftp://example.com', 'http ://example.com', 'http://example. com').for(:url) }
  end
end
