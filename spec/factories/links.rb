# frozen_string_literal: true

FactoryBot.define do
  sequence(:link_title) { |n| "Test link #{n}" }

  factory :link do
    title { generate(:link_title) }
    url { 'https://test.com' }
  end
end
