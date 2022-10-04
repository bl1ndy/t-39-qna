# frozen_string_literal: true

class AnswersChannel < ApplicationCable::Channel
  def subscribed
    reject if params[:question].blank?
  end

  def follow
    stream_from "question_#{params[:question]}"
  end
end
