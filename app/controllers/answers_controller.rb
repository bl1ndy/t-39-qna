# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :set_answer, only: %i[update destroy best destroy_file destroy_link]
  before_action :set_question, only: %i[update destroy best]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params.merge(user: current_user))

    publish_answer if @answer.save

    @answer_comment = @answer.comments.build
    @new_answer = @question.answers.build
    @new_answer.links.build
  end

  def update
    authorize @answer

    @best_answer = @question.best_answer

    @answer.update(answer_params)
    @answer_comment = @answer.comments.build
  end

  def destroy
    authorize @answer

    @answer.destroy
  end

  def best
    authorize @answer

    @question.mark_as_best(@answer)
    @question.reward&.update(user: @answer.user)
  end

  def destroy_file
    authorize @answer

    @file = ActiveStorage::Attachment.find(params[:file_id])
    @file.purge
  end

  def destroy_link
    authorize @answer

    @link = Link.find(params[:link_id])
    @link.destroy
  end

  private

  def publish_answer
    html = ApplicationController.render(
      partial: 'answers/answer_simplified',
      locals: { answer: @answer }
    )

    ActionCable.server.broadcast(
      "question_#{@question.id}",
      { html:, author_id: @answer.user.id }
    )
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id title url])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = @answer.question
  end
end
