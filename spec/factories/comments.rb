# frozen_string_literal: true

FactoryBot.define do
  sequence(:comment_body) { |n| "MyComment-#{n}-Text" }

  factory :comment do
    body { generate(:comment_body) }

    trait :invalid do
      body { nil }
    end
  end
end
