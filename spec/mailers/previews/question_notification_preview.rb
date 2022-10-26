# frozen_string_literal: true

class QuestionNotificationPreview < ActionMailer::Preview
  def notify
    user = FactoryBot.create(:user)
    question = FactoryBot.create(:question)

    QuestionNotificationMailer.notify(question, user)
  end
end
