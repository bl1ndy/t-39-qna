# frozen_string_literal: true

class Answer < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  belongs_to :user
  belongs_to :question

  has_many_attached :files

  validates :body, presence: true

  after_create :notify_question_subscribers

  private

  def notify_question_subscribers
    QuestionNotificationJob.perform_later(question)
  end
end
