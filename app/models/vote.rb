# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :rate, numericality: { only_integer: true }
  validates :votable_id, uniqueness: {
    scope: %i[votable_type user_id],
    message: 'You have already voted for this post'
  }
  validate :validate_rate_value
  validate :validate_vote_author

  AVAILABLE_RATE_VALUES = [-1, 1].freeze

  def validate_rate_value
    errors.add(:rate, 'must be 1 or -1') unless AVAILABLE_RATE_VALUES.include?(rate)
  end

  def validate_vote_author
    errors.add(:base, "You can't vote for your own post") if votable&.user == user
  end
end
