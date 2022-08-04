# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create update destroy]
  before_action :set_answer, only: %i[update destroy]
  before_action :set_question, only: :create

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    @question = @answer.question

    if current_user == @answer.user
      @answer.update(answer_params)
    else
      head :forbidden
    end
  end

  def destroy
    @question = @answer.question

    if current_user == @answer.user
      @answer.destroy
    else
      head :forbidden
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
