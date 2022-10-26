# frozen_string_literal: true

class Subscription < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :question_id, uniqueness: { scope: :user_id }
end
