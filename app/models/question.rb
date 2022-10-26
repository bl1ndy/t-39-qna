# frozen_string_literal: true

class Question < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', optional: true

  has_one :reward, dependent: :destroy

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  def mark_as_best(answer)
    update(best_answer: answer)
  end

  def subscribed_by?(user)
    subscriptions.find_by(user:)
  end
end
