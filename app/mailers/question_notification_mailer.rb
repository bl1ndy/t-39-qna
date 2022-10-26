# frozen_string_literal: true

class QuestionNotificationMailer < ApplicationMailer
  def notify(question, user)
    @question = question

    mail to: user.email, subject: 'New answer received'
  end
end
