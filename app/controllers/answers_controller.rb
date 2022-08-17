# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[update destroy best destroy_file]
  before_action :set_question, only: %i[update destroy best]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    @best_answer = @question.best_answer

    if current_user == @answer.user
      @answer.update(answer_params)
    else
      head :forbidden
    end
  end

  def destroy
    if current_user == @answer.user
      @answer.destroy
    else
      head :forbidden
    end
  end

  def best
    if current_user == @question.user
      @question.mark_as_best(@answer)
    else
      head :forbidden
    end
  end

  def destroy_file
    @file = ActiveStorage::Attachment.find(params[:file_id])

    if current_user == @answer.user
      @file.purge
    else
      head :forbidden
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = @answer.question
  end
end
