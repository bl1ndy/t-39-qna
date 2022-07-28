# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    title { 'MyQuestionTitle' }
    body { 'MyQuestionText' }

    trait :invalid do
      title { nil }
    end
  end
end
