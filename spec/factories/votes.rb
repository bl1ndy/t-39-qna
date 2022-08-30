# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    association :user
    association :votable, factory: :question

    rate { 1 }
  end
end
