# frozen_string_literal: true

class Api::V1::AnswersController < Api::V1::BaseController
  def index
    render json: question.answers
  end

  def show
    answer = question.answers.find(params[:id])

    render json: answer
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end
end
