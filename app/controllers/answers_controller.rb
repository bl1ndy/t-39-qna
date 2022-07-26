# frozen_string_literal: true

class AnswersController < ApplicationController
  expose :question

  def create
    answer = question.answers.build(answer_params)

    if answer.save
      redirect_to question
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
