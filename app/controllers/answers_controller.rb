# frozen_string_literal: true

class AnswersController < ApplicationController
  expose :question
  expose :answers, -> { question.answers.select(&:persisted?) }
  expose :answer, :set_answer

  def create
    answer.user = current_user

    if answer.save
      redirect_to question, notice: 'Your Answer successfully created!'
    else
      render 'questions/show'
    end
  end

  def destroy
    answer.destroy

    redirect_to question, notice: 'Your Answer successfully deleted!'
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_answer
    if params[:id]
      Answer.find(params[:id])
    elsif params[:answer]
      question.answers.build(answer_params)
    else
      question.answers.build
    end
  end
end
