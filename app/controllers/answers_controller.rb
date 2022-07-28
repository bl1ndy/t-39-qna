# frozen_string_literal: true

class AnswersController < ApplicationController
  expose :question
  expose :answers, -> { question.answers.select(&:persisted?) }
  expose :answer, -> { question.answers.build(answer_params) }

  def create
    if answer.save
      redirect_to question, notice: 'Your Answer successfully created!'
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
