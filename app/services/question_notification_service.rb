# frozen_string_literal: true

class QuestionNotificationService
  def initialize(question)
    @question = question
    @subscribers = question.subscriptions.map(&:user)
  end

  def call
    @subscribers.each { |user| QuestionNotificationMailer.notify(@question, user).deliver_later }
  end
end
