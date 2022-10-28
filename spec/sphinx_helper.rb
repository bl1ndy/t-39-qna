# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before do
    # Default to transaction strategy for all specs
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:suite) do
    # Ensure sphinx directories exist for the test environment
    ThinkingSphinx::Test.init
    # Configure and start Sphinx, and automatically
    # stop Sphinx at the end of the test suite.
    ThinkingSphinx::Test.start_with_autostop
  end

  config.before(:each, sphinx: true) do
    # For tests tagged with Sphinx, use deletion (or truncation)
    DatabaseCleaner.strategy = :deletion
  end

  config.before do
    DatabaseCleaner.start
  end

  config.append_after do
    DatabaseCleaner.clean
  end
end
