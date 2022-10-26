# frozen_string_literal: true

class QuestionNotificationJob < ApplicationJob
  queue_as :default

  def perform(question)
    QuestionNotificationService.new(question).call
  end
end
