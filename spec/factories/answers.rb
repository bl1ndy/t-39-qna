# frozen_string_literal: true

FactoryBot.define do
  sequence(:body) { |n| "MyAnswer-#{n}-Text" }

  factory :answer do
    association :question

    body

    trait :invalid do
      body { nil }
    end
  end
end
