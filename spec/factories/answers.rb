# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    association :question

    body { 'MyAnswerText' }

    trait :invalid do
      body { nil }
    end
  end
end
